# encoding: utf-8
require "test_helper"

class SearchControllerTest < ActionController::TestCase

  def a_search_result(slug, score=1)
    {
      "title" => slug.titleize,
      "description" => "Description for #{slug}",
      "link" => "/#{slug}",
      "es_score" => score
    }
  end

  def result_with_organisation(acronym, title, slug)
    {
      "title" => "Something by #{title}",
      "format" => "something",
      "es_score" => 0.1,
      "organisations" => [
        {
          "acronym" => acronym,
          "title" => title,
          "slug" => slug
        }
      ]
    }
  end

  # spelling_suggestions - an array of string spelling suggestions.
  #                        Defaults to empty list.
  #                        Explicitly passing "nil" means they key is excluded,
  #                        Which allows testing against Rummager before the
  #                        feature was added.
  def stub_results(index_name, search_results = [], spelling_suggestions = [])
    response_body = {
      "total" => search_results.size,
      "results" => search_results
    }
    unless spelling_suggestions.nil?
      response_body["spelling_suggestions"] = spelling_suggestions
    end
    client = stub("search #{index_name}", search: response_body)
    Frontend.stubs(:"#{index_name}_search_client").returns(client)
  end

  setup do
    stub_results("mainstream", [])
    stub_results("detailed_guidance", [])
    stub_results("government", [])

    organisations_client = stub("search", organisations: { "total" => 0, "results" => [] })
    Frontend.stubs(:organisations_search_client).returns(organisations_client)
  end

  test "should ask the user to enter a search term if none was given" do
    get :index, q: ""
    assert_select "label", %{Search GOV.UK}
    assert_select "form[action=?]", search_path do
      assert_select "input[name=q]"
    end
  end

  test "should inform the user that we didn't find any documents matching the search term" do
    get :index, q: "search-term"
    assert_select ".no-results h2", text: %Q{No results for &ldquo;search-term&rdquo;}
  end

  test "should pass our query parameter in to the search client" do
    Frontend.mainstream_search_client.expects(:search).with("search-term", response_style: "hash", minimum_should_match: "1").returns("results" => []).once
    get :index, q: "search-term"
  end

  test "should include link to JSON version in HTML header" do
    stub_results("mainstream", [{}, {}, {}])
    get :index, q: "search-term"
    assert_select 'head link[rel=alternate]' do |elements|
      assert elements.any? { |element|
        element['href'] == '/api/search.json?q=search-term'
      }
    end
  end

  test "should display single result with specific class name attribute" do
    stub_results("mainstream", [a_search_result("a"), a_search_result("b"), a_search_result("c"), a_search_result("d")])
    get :index, q: "search-term"
    assert_select "div#services-information-results.single-item-pane"
  end

  test "should display multiple results without class name for single result set" do
    stub_results("mainstream", [a_search_result("a"), a_search_result("b")])
    get :index, q: "search-term"
    assert_select "div#services-information-results.single-item-pane", 0
  end

  test "should display tabs when there are results in one or more tab" do
    stub_results("mainstream", [a_search_result("a"), a_search_result("b"), a_search_result("c")])
    stub_results("government", [a_search_result("x")])
    get :index, q: "search-term"
    assert_select "div.js-tabs"
  end

  test "should display no tabs when there are no results" do
    get :index, q: "search-term"
    assert_select "div.js-tabs", count: 0
  end

  test "should not display tabs there are only top-results" do
    stub_results("mainstream", [a_search_result("a")])
    get :index, q: "search-term"
    assert_select "div.js-tabs", count: 0
  end

  context "active tab" do
    context "no tab parameter given" do
      should "not 'remember' the tab we've defaulted to for the user" do
        get :index, q: "search-term"
        assert_select "form.search-header input[name=tab]"
        assert_select "form.search-header input[name=tab][value=*]", count: 0
      end
    end

    context "tab parameter given" do
      should "remember the tab the user has chosen" do
        get :index, q: "search-term", tab: "government-results"
        assert_select "form.search-header input[name=tab]"
        assert_select "form.search-header input[name=tab][value='government-results']"
      end
    end
  end

  context "one tab has results, the others do not" do
    should "display the 'no results' html in the tabs without results" do
      # Three results to fill up the top-results, one to be displayed in the tab
      stub_results("government", [a_search_result("a"), a_search_result("b"), a_search_result("c"), a_search_result("d")])
      get :index, q: "search-term"
      assert_select "div.js-tabs"
      assert_select "#services-information-results .no-results", /No results in Services and information/
    end
  end

  context "tab parameter is set, another tab has results" do
    should "focus on that tab, even if it has no results" do
      stub_results("mainstream", [a_search_result("x")])
      # Three results to fill top-results, one to force the tab to be displayed
      stub_results("government", [a_search_result("a"), a_search_result("b"), a_search_result("c"), a_search_result("d")])
      get :index, { q: "spoon", tab: "government-results" }
      assert_select "li.active a[href=#government-results]"
    end
  end

  context "one tab has results, the other doesn't. no tab parameter supplied" do
    should "should focus on the tab with results" do
      # 4 results. Subtract 3 for top results leaves you one inside the tab
      stub_results("government", [a_search_result("a"), a_search_result("b"), a_search_result("c"), a_search_result("d")])
      get :index, { q: "spoon" }
      assert_select "li.active a[href=#government-results]"
    end
  end

  test "should display a link to the documents matching our search criteria" do
    stub_results("mainstream", [{"title" => "document-title", "link" => "/document-slug"}])
    get :index, q: "search-term"
    assert_select "a[href='/document-slug']", text: "document-title"
  end

  test "should set the class of the result according to the format" do
    stub_results("mainstream", [{"title" => "title", "link" => "/slug", "highlight" => "", "format" => "publication"}])
    get :index, q: "search-term"
    assert_select ".results-list .type-publication"
  end

  test "should_not_blow_up_with_a_result_wihout_a_section" do
    result_without_section = {
      "title" => "TITLE1",
      "description" => "DESCRIPTION",
      "link" => "/URL"
    }
    stub_results("mainstream", [result_without_section])
    assert_nothing_raised do
      get :index, {q: "bob"}
    end
  end

  test "should include sections in results" do
    result_with_section = {
      "title" => "TITLE1",
      "description" => "DESCRIPTION",
      "link" => "/url",
      "section" => "life-in-the-uk"
    }
    stub_results("mainstream", [result_with_section])
    get :index, {q: "bob"}

    assert_select '.meta .section', text: "Life in the UK"
  end

  test "should include sub-sections in results" do
    result_with_section = {
      "title" => "TITLE1",
      "description" => "DESCRIPTION",
      "link" => "/url",
      "section" => "life-in-the-uk",
      "subsection" => "test-thing"
    }
    stub_results("mainstream", [result_with_section])
    get :index, {q: "bob"}

    assert_select '.meta .section', text: "Life in the UK"
    assert_select '.meta .subsection', text: 'Test thing'
  end

  test "should include sub-sub-sections in results" do
    result_with_section = {
      "title" => "TITLE1",
      "description" => "DESCRIPTION",
      "link" => "/url",
      "section" => "life-in-the-uk",
      "subsection" => "test-thing",
      "subsubsection" => "sub-section"
    }
    stub_results("mainstream", [result_with_section])
    get :index, {q: "bob"}

    assert_select '.meta .section', text: "Life in the UK"
    assert_select '.meta .subsection', text: 'Test thing'
    assert_select '.meta .subsubsection', text: 'Sub section'
  end

  should "include organisations where available" do
    results = [
      a_search_result("a"),
      a_search_result("b"),
      a_search_result("c"),
      result_with_organisation("CO", "Cabinet Office", "cabinet-office")
    ]
    stub_results("government", results)
    get :index, { q: "bob" }

    assert_select "ul.attributes li", /CO/
  end

  should "provide an abbr tag to explain organisation abbreviations" do
    results = [
      a_search_result("a"),
      a_search_result("b"),
      a_search_result("c"),
      result_with_organisation("CO", "Cabinet Office", "cabinet-office")
    ]
    stub_results("government", results)
    get :index, { q: "bob" }

    assert_select "ul.attributes li abbr[title='Cabinet Office']", text: "CO"
  end

  test "should return unlimited results" do
    results = []
    75.times do |n|
      results << a_search_result("result-#{n}")
    end
    stub_results("mainstream", results)

    get :index, q: "Test"
    assert_select "#services-information-results h3 a", count: 72 # 75 -3 top results
  end

  test "should show the phrase searched for" do
    stub_results("mainstream", Array.new(75, {}))

    get :index, q: "Test"

    assert_select 'input[value=Test]'
  end

  test "should_show_external_links_with_a_separate_list_class" do
    external_document = {
      "title" => "A title",
      "description" => "This is a description",
      "link" => "http://twitter.com",
      "section" => "driving",
      "format" => "recommended-link"
    }

    stub_results("mainstream", [external_document])

    get :index, {q: "bleh"}
    assert_select ".recommended-links li.external" do
      assert_select "a[rel=external]", "A title"
    end
  end

  test "should show external links in a separate column" do
    external_document = {
      "title" => "A title",
      "description" => "This is a description",
      "link" => "http://twitter.com",
      "section" => "driving",
      "format" => "recommended-link"
    }

    stub_results("mainstream", [external_document])

    get :index, {q: "bleh"}
    assert_select ".recommended-links li.external" do
      assert_select "a[rel=external]", "A title"
    end
    assert_select '.internal-links li.external', count: 0
  end

  test "should send analytics headers for citizen proposition" do
    get :index, {q: "bob"}
    assert_equal "search",  response.headers["X-Slimmer-Section"]
    assert_equal "search",  response.headers["X-Slimmer-Format"]
    assert_equal "citizen", response.headers["X-Slimmer-Proposition"]
    assert_equal "0",       response.headers["X-Slimmer-Result-Count"]
  end

  test "result count header with results" do
    stub_results("mainstream", Array.new(15, {}))

    get :index, {q: "bob"}

    assert_equal "15", response.headers["X-Slimmer-Result-Count"]
  end

  test "truncate long external URLs to a fixed length" do
    external_link = {
      "title" => "A title",
      "description" => "This is a description",
      "link" => "http://www.weally.weally.long.url.com/weaseling/about/the/world",
      "section" => "driving",
      "format" => "recommended-link"
    }

    stub_results("mainstream", Array.new(1, external_link))

    get :index, {q: "bleh"}

    assert_response :success
    assert_select 'li.type-guide.external .meta' do
      assert_select '.url', {count: 1, text: "http://www.weally.weally.long.url.com/weaseli..."}
    end
  end

  test "should handle service errors with a 503" do
    Frontend.mainstream_search_client.stubs(:search).raises(GdsApi::BaseError)
    get :index, {q: "badness"}

    assert_response 503
  end

  context "?spelling_suggestion=1" do
    context "spelling suggestions NOT returned" do
      should "not display a spelling suggestion link" do
        # temporary backwards compatibility with pre-suggestive rummager
        stub_results("mainstream", [], nil)
        get :index, { q: "afgananinanistan", spelling_suggestion: "1" }

        assert_response :ok
        assert_select ".spelling-suggestion", count: 0
      end
    end

    context "spelling suggestions returned" do
      should "display a link to the first suggestion from mainstream" do
        stub_results("mainstream", [], ["afghanistan"])
        get :index, { q: "afgananinanistan", spelling_suggestion: "1" }

        assert_select ".spelling-suggestion a", 'afghanistan'
      end
    end
  end

  context "organisation filter" do
    setup do
      # Need to have 4+ results for the tab to appear
      stub_results("government", [
          a_search_result("c", 3),
          a_search_result("d", 3),
          a_search_result("e", 3),
          a_search_result("f", 3)])
    end

    should "appear on the government tab" do
      get :index, { q: "moon" }
      assert_select "#government-results form#government-filter"
    end

    should "list organisations split into ministerial departments and others" do
      organisations = [
        {
          "link"              => "/government/organisations/ministry-of-defence",
          "title"             => "Ministry of Defence",
          "acronym"           => "MOD",
          "organisation_type" => "Ministerial department",
          "slug"              => "ministry-of-defence"
        },
        {
          "link"              => "/government/organisations/agency-of-awesome",
          "title"             => "Agency of Awesome",
          "acronym"           => "AoA",
          "slug"              => "agency-of-awesome"
        }
      ]
      Frontend.organisations_search_client
          .expects(:organisations)
          .returns({ "results" => organisations })
      get :index, { q: "sun" }
      assert_select "select#organisation-filter optgroup[label='Ministerial departments'] option[value=ministry-of-defence]"
      assert_select "select#organisation-filter optgroup[label='Others'] option[value=agency-of-awesome]"
    end

    should "new searches should retain the organisation filter" do
      get :index, { q: "moon", organisation: "ministry-of-defence" }
      assert_select "#content form[role=search] input[name=organisation][value=ministry-of-defence][type=hidden]"
    end

    should "retain tab parameter" do
      get :index, { q: "moon", tab: "government-results" }
      assert_select "form#government-filter input[name=tab][value=government-results]"
    end

    should "select the current organisation in the dropdown" do
      Frontend.organisations_search_client.stubs(:organisations).returns({ "total" => 0, "results" => [{
          "link"              => "/government/organisations/ministry-of-defence",
          "title"             => "Ministry of Defence",
          "acronym"           => "MOD",
          "organisation_type" => "Ministerial department",
          "slug"              => "ministry-of-defence"

        }] })
      get :index, { q: "moon", organisation: "ministry-of-defence" }
      assert_select "select#organisation-filter option[value=ministry-of-defence][selected=selected]"
    end

    should "let you filter results by organisation" do
      Frontend.government_search_client
          .expects(:search)
          .with("moon", organisation_slug: "ministry-of-defence", response_style: "hash", minimum_should_match: "1")
          .returns("results" => [])
      get :index, { q: "moon", organisation: "ministry-of-defence" }
    end

    context "filter applied, but no search results in any tab" do
      should "force the tabs to be displayed, so that you can see a filter is active" do
        # TODO see if we can remove the stub from the context setup up a level
        stub_results("government", [])
        get :index, { q: "moon", organisation: "ministry-of-defence" }
        assert_select "div.js-tabs"
        assert_select "#government-results h3 a", count: 0
      end
    end

    context "filter applied, but only top-results, therefore no results in tabs" do
      should "force the tabs to be displayed, so that you can see a filter is active" do
        # TODO see if we can remove the stub from the context setup up a level
        stub_results("government", [a_search_result("a"), a_search_result("b"), a_search_result("c")])
        get :index, { q: "moon", organisation: "ministry-of-defence" }
        assert_select "div.js-tabs"
        assert_select "#government-results h3 a", count: 0
      end
    end
  end

  context "top results" do
    should "remove the highest 3 scored results from the three tabs and display above all others" do
      stub_results("mainstream", [a_search_result("a", 1)])
      stub_results("detailed_guidance", [a_search_result("b", 2)])
      stub_results("government", [a_search_result("c", 3)])

      get :index, q: "search-term", top_result: "1"

      assert_select "#services-information-results h3 a", count: 0
      assert_select "#government-results h3 a", count: 0

      assert_select "#top-results a[href='/a']"
      assert_select "#top-results a[href='/b']"
      assert_select "#top-results a[href='/c']"
    end

    should "extract top results from unfiltered government results" do
      unfiltered_body = {
        "total" => 1,
        "results" => [a_search_result("a", 1)]
      }
      filtered_body = {
        "total" => 1,
        "results" => [a_search_result("b", 1)]
      }
      government_client = stub("search government") do
        expects(:search)
          .with("search-term", response_style: "hash", minimum_should_match: "1")
          .returns(unfiltered_body)
        expects(:search)
          .with("search-term", organisation_slug: "bob", response_style: "hash", minimum_should_match: "1")
          .returns(filtered_body)
      end

      Frontend.stubs(:government_search_client).returns(government_client)

      get :index, q: "search-term", top_result: "1", organisation: "bob"

      assert_select "#top-results a[href='/a']"
      assert_select "#top-results a[href='/b']", count: 0
    end

    should "not show duplicate results in a filtered tab" do
      unfiltered_body = {
        "total" => 1,
        "results" => [a_search_result("a", 1)]
      }
      filtered_body = {
        "total" => 1,
        "results" => [a_search_result("a", 1), a_search_result("b", 1)]
      }
      government_client = stub("search government") do
        expects(:search)
          .with("search-term", response_style: "hash", minimum_should_match: "1")
          .returns(unfiltered_body)
        expects(:search)
          .with("search-term", organisation_slug: "bob", response_style: "hash", minimum_should_match: "1")
          .returns(filtered_body)
      end

      Frontend.stubs(:government_search_client).returns(government_client)

      get :index, q: "search-term", top_result: "1", organisation: "bob"

      assert_select "#top-results a[href='/a']"
      assert_select "#government-results a[href='/a']", count: 0
    end
  end

  should "merge mainstream and detailed results in one tab" do
    stub_results("mainstream", [{ "es_score" => 1 }, { "es_score" => 1 }, { "es_score" => 1 }])
    stub_results("detailed_guidance", [{ "es_score" => 1 }])
    # Let the government results be used for top_results
    stub_results("government", [a_search_result("x", 10), a_search_result("y", 10), a_search_result("z", 10)])
    get :index, { q: "tax" }
    assert_select "#services-information-results h3 a", count: 4
  end

  should "correctly sort the merged mainstream and detailed results" do
    stub_results("mainstream", [a_search_result("high", 10)])
    stub_results("detailed_guidance", [a_search_result("low", 5)])
    get :index, { q: "tax" }
    assert_select 'li:first-child  h3 a[href=/high]'
    assert_select 'li:nth-child(2) h3 a[href=/low]'
  end

  should "hackily downweight detailed results to prevent them from swamping better mainstream results" do
    stub_results("mainstream", [a_search_result("mainstream", 100)])
    stub_results("detailed_guidance", [a_search_result("detailed", 101)])
    get :index, { q: "tax" }
    assert_select 'li:first-child  h3 a[href=/mainstream]'
    assert_select 'li:nth-child(2) h3 a[href=/detailed]'
  end

  should "hackily downweight government results to allow mainstream/detailed results to rank better" do
    stub_results("mainstream", [a_search_result("mainstream-a", 100), a_search_result("mainstream-b", 1)])
    stub_results("government", [a_search_result("government", 101)])
    get :index, { q: "tax" }
    assert_select '#top-results li:first-child  h3 a[href=/mainstream-a]'
    assert_select '#top-results li:nth-child(2) h3 a[href=/government]'
    assert_select '#top-results li:nth-child(3) h3 a[href=/mainstream-b]'
  end
end
