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
  def stub_combined_results(result_map, spelling_suggestions = [], parameters = {})
    response_body = combined_response(result_map, spelling_suggestions)
    Frontend.combined_search_client.stubs(:search)
        .with(is_a(String), parameters)
        .returns(response_body)
  end

  def stub_single_result(result)
    stub_combined_results({
      "top-results" => [result],
      "services-information" => [],
      "departments-policy" => []
    })
  end

  def combined_response(result_map, spelling_suggestions = [])
    titles = {
      "top-results" => "Top results",
      "services-information" => "Services and information",
      "departments-policy" => "Departments and policy"
    }
    response_body = {
      "streams" => {}
    }
    result_map.each do |key, results|
      response_body["streams"][key] = {
        "results" => results,
        "total" => results.count,
        "title" => titles[key]
      }
    end
    unless spelling_suggestions.nil?
      response_body["spelling_suggestions"] = spelling_suggestions
    end

    response_body
  end

  def no_results
    combined_response({
      "top-results" => [],
      "services-information" => [],
      "departments-policy" => []
    })
  end

  setup do
    stub_combined_results({
      "top-results" => [],
      "services-information" => [],
      "departments-policy" => []
    })

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
    Frontend.combined_search_client.expects(:search)
        .with("search-term", {})
        .returns(no_results)
        .once
    get :index, q: "search-term"
  end

  test "should include link to JSON version in HTML header" do
    stub_combined_results("top-results" => [{}])
    get :index, q: "search-term"
    assert_select 'head link[rel=alternate]' do |elements|
      assert elements.any? { |element|
        element['href'] == '/api/search.json?q=search-term'
      }
    end
  end

  test "should display single result with specific class name attribute" do
    stub_combined_results({
      "top-results" => [],
      "services-information" => [a_search_result("a")],
      "departments-policy" => []
    })
    get :index, q: "search-term"
    assert_select "div#services-information-results.single-item-pane"
  end

  test "should display multiple results without class name for single result set" do
    stub_combined_results({
      "top-results" => [a_search_result("a")],
      "services-information" => [],
      "departments-policy" => []
    })
    get :index, q: "search-term"
    assert_select "div#services-information-results.single-item-pane", 0
  end

  test "should display tabs when there are results in one or more tab" do
    stub_combined_results({
      "top-results" => [],
      "services-information" => [a_search_result("a")],
      "departments-policy" => [a_search_result("b")],
    })
    get :index, q: "search-term"
    assert_select "div.js-tabs"
  end

  test "should display no tabs when there are no results" do
    get :index, q: "search-term"
    assert_select "div.js-tabs", count: 0
  end

  test "should not display tabs there are only top-results" do
    stub_combined_results({
      "top-results" => [a_search_result("a")],
      "services-information" => [],
      "departments-policy" => []
    })
    get :index, q: "search-term"
    assert_select "div.js-tabs", count: 0
  end

  context "active tab" do
    context "no tab parameter given" do
      should "not 'remember' the tab we've defaulted to for the user" do
        get :index, q: "search-term"
        assert_select "form.search-header input[name=tab]", count: 0
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
      stub_combined_results({
        "top-results" => [],
        "services-information" => [],
        "departments-policy" => [a_search_result("a")]
      })
      get :index, q: "search-term"
      assert_select "div.js-tabs"
      assert_select "#services-information-results .no-results", /No results in Services and information/
    end
  end

  context "tab parameter is set, another tab has results" do
    should "focus on that tab, even if it has no results" do
      stub_combined_results({
        "top-results" => [],
        "services-information" => [a_search_result("a")],
        "departments-policy" => [a_search_result("b")]
      })
      get :index, { q: "spoon", tab: "government-results" }
      assert_select "li.active a[href=#government-results]"
    end
  end

  context "one tab has results, the other doesn't. no tab parameter supplied" do
    should "should focus on the tab with results" do
      stub_combined_results({
        "top-results" => [],
        "services-information" => [],
        "departments-policy" => [a_search_result("b")]
      })
      get :index, { q: "spoon" }
      assert_select "li.active a[href=#government-results]"
    end
  end

  test "should display a link to the documents matching our search criteria" do
    result = {"title" => "document-title", "link" => "/document-slug"}
    stub_single_result(result)

    get :index, q: "search-term"
    assert_select "a[href='/document-slug']", text: "document-title"
  end

  test "should set the class of the result according to the format" do
    result = {
      "title" => "title",
      "link" => "/slug",
      "highlight" => "",
      "format" => "publication"
    }
    stub_single_result(result)
    get :index, q: "search-term"

    assert_select ".results-list .type-publication"
  end

  test "should_not_blow_up_with_a_result_wihout_a_section" do
    result_without_section = {
      "title" => "TITLE1",
      "description" => "DESCRIPTION",
      "link" => "/URL"
    }
    stub_single_result(result_without_section)
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
    stub_single_result(result_with_section)
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
    stub_single_result(result_with_section)
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
    stub_single_result(result_with_section)
    get :index, {q: "bob"}

    assert_select '.meta .section', text: "Life in the UK"
    assert_select '.meta .subsection', text: 'Test thing'
    assert_select '.meta .subsubsection', text: 'Sub section'
  end

  should "include organisations where available" do
    result = result_with_organisation("CO", "Cabinet Office", "cabinet-office")
    stub_combined_results({
      "top-results" => [],
      "services-information" => [],
      "departments-policy" => [result]
    })
    get :index, { q: "bob" }

    assert_select "ul.attributes li", /CO/
  end

  should "provide an abbr tag to explain organisation abbreviations" do
    result = result_with_organisation("CO", "Cabinet Office", "cabinet-office")
    stub_combined_results({
      "top-results" => [],
      "services-information" => [],
      "departments-policy" => [result]
    })
    get :index, { q: "bob" }

    assert_select "ul.attributes li abbr[title='Cabinet Office']", text: "CO"
  end

  should "not provide an abbr tag when the organisation title is the acronym" do
    result = result_with_organisation("Home Office", "Home Office", "home-office")
    stub_combined_results({
      "top-results" => [],
      "services-information" => [],
      "departments-policy" => [result]
    })
    get :index, { q: "bob" }

    assert_select "ul.attributes li abbr[title='Home Office']", count: 0
    assert_select "ul.attributes li", /Home Office/
  end

  test "should return unlimited results" do
    results = []
    75.times do |n|
      results << a_search_result("result-#{n}")
    end
    stub_combined_results({
      "top-results" => [],
      "services-information" => results,
      "departments-policy" => []
    })

    get :index, q: "Test"
    assert_select "#services-information-results h3 a", count: 75
  end

  test "should show the phrase searched for" do
    stub_combined_results({
      "top-results" => [],
      "services-information" => Array.new(75, {}),
      "departments-policy" => []
    })

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

    stub_single_result(external_document)

    get :index, {q: "bleh"}
    assert_select "li.external" do
      assert_select "a[rel=external]", "A title"
    end
  end

  test "should send analytics headers for citizen proposition" do
    get :index, {q: "bob"}
    assert_equal "search",  response.headers["X-Slimmer-Section"]
    assert_equal "search",  response.headers["X-Slimmer-Format"]
    assert_equal "citizen", response.headers["X-Slimmer-Proposition"]
    assert_equal "0",       response.headers["X-Slimmer-Result-Count"]
  end

  test "display the total number of results" do
    stub_combined_results({
      "top-results" => Array.new(15, {}),
      "services-information" => [],
      "departments-policy" => []
    })

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
    stub_single_result(external_link)

    get :index, {q: "bleh"}

    assert_response :success
    assert_select 'li.type-guide.external .meta' do
      assert_select '.url', {count: 1, text: "www.weally.weally.long.url.com/weaseling/abou..."}
    end
  end

  test "should remove the scheme from external URLs" do
    external_link = {
      "title" => "A title",
      "description" => "This is a description",
      "link" => "http://www.badgers.com/badgers",
      "format" => "recommended-link"
    }
    stub_single_result(external_link)

    get :index, {q: "bleh"}

    assert_response :success
    assert_select 'li.type-guide.external .meta' do
      assert_select '.url', {count: 1, text: "www.badgers.com/badgers"}
    end
  end

  test "should remove the scheme from HTTPS URLs" do
    external_link = {
      "title" => "A title",
      "description" => "This is a description",
      "link" => "https://www.badgers.com/badgers",
      "format" => "recommended-link"
    }
    stub_single_result(external_link)

    get :index, {q: "bleh"}

    assert_response :success
    assert_select 'li.type-guide.external .meta' do
      assert_select '.url', {count: 1, text: "www.badgers.com/badgers"}
    end
  end

  test "should handle service errors with a 503" do
    Frontend.combined_search_client.stubs(:search).raises(GdsApi::BaseError)
    get :index, {q: "badness"}

    assert_response 503
  end

  context "spelling suggestions" do
    should "display a link to the first suggestion from mainstream" do
      no_results = {
        "top-results" => [],
        "services-information" => [],
        "departments-policy" => []
      }
      stub_combined_results(no_results, ["afghanistan"])

      get :index, { q: "afgananinanistan" }

      assert_select ".spelling-suggestion a", 'afghanistan'
    end
  end

  context "organisation filter" do
    context "on an unfiltered request" do
      setup do
        stub_combined_results({
          "top-results" => [],
          "services-information" => [],
          "departments-policy" => [a_search_result("f", 3)]
        })
      end

      should "not pass blank organisation values to search" do
        # If this isn't filtered out, it'll break stubbing
        get :index, q: "moon", organisation: ""
      end

      should "appear on the government tab" do
        get :index, { q: "moon" }
        assert_select "#government-results form#government-filter"
      end

      should "list organisations split into ministerial departments, others and closed" do
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
          },
          {
            "link"              => "/government/organisations/defunct-department",
            "title"             => "Defunct Department",
            "acronym"           => "DD",
            "slug"              => "defunct-department",
            "organisation_state" => "closed"
          }
        ]
        Frontend.organisations_search_client
            .expects(:organisations)
            .returns({ "results" => organisations })
        get :index, { q: "sun" }
        assert_select "select#organisation-filter optgroup[label='Ministerial departments'] option[value=ministry-of-defence]"
        assert_select "select#organisation-filter optgroup[label='Other departments &amp; public bodies'] option[value=agency-of-awesome]"
        assert_select "select#organisation-filter optgroup[label='Closed organisations'] option[value=defunct-department]"
      end

      should "retain tab parameter" do
        get :index, { q: "moon", tab: "government-results" }
        assert_select "form#government-filter input[name=tab][value=government-results]"
      end
    end

    context "on a filtered request" do
      setup do
        search_response = combined_response({
          "top-results" => [],
          "services-information" => [],
          "departments-policy" => [a_search_result("f", 3)]
        })
        Frontend.combined_search_client
          .expects(:search)
          .with("moon", "organisation_slug" => "ministry-of-defence")
          .returns(search_response)
        Frontend.organisations_search_client.stubs(:organisations).returns({ "total" => 0, "results" => [{
            "link"              => "/government/organisations/ministry-of-defence",
            "title"             => "Ministry of Defence",
            "acronym"           => "MOD",
            "organisation_type" => "Ministerial department",
            "slug"              => "ministry-of-defence"

          }] })
      end

      should "select the current organisation in the dropdown" do
        get :index, { q: "moon", organisation: "ministry-of-defence" }
        assert_select "select#organisation-filter option[value=ministry-of-defence][selected=selected]"
      end

      should "let you filter results by organisation" do
        get :index, { q: "moon", organisation: "ministry-of-defence" }
      end

      should "retain the organisation filter in new searches" do
        get :index, { q: "moon", organisation: "ministry-of-defence" }
        assert_select "#content form[role=search] input[name=organisation][value=ministry-of-defence][type=hidden]"
      end
    end

    context "filter applied, but no search results in any tab" do
      should "force the tabs to be displayed, so that you can see a filter is active" do
        # TODO see if we can remove the stub from the context setup up a level
        Frontend.combined_search_client
          .expects(:search)
          .with("moon", "organisation_slug" => "ministry-of-defence")
          .returns(no_results)
        get :index, { q: "moon", organisation: "ministry-of-defence" }
        assert_select "div.js-tabs"
        assert_select "#government-results h3 a", count: 0
      end
    end

    context "filter applied, but only top-results, therefore no results in tabs" do
      should "force the tabs to be displayed, so that you can see a filter is active" do
        # TODO see if we can remove the stub from the context setup up a level
        results = [a_search_result("a"), a_search_result("b"), a_search_result("c")]
        search_response = combined_response({
          "top-results" => results,
          "services-information" => [],
          "departments-policy" => []
        })
        Frontend.combined_search_client
          .expects(:search)
          .with("moon", "organisation_slug" => "ministry-of-defence")
          .returns(search_response)
        get :index, { q: "moon", organisation: "ministry-of-defence" }
        assert_select "div.js-tabs"
        assert_select "#government-results h3 a", count: 0
      end
    end
  end

  context "sorting results" do

    context "on an unsorted request" do
      setup do
        # Ensure tabs are displayed
        stub_combined_results({
          "top-results" => [],
          "services-information" => [a_search_result("d", 3)],
          "departments-policy" => [a_search_result("d", 3)]
        })
      end

      should "default the sort to relevance (blank value)" do
        get :index, q: "glass"
        assert_select "input[name=sort][value=''][checked]"
      end

      should "not pass on blank sort values to search" do
        # If this isn't stripped out, it breaks the test stub
        get :index, q: "glass", sort: ""
      end
    end

    context "on a sorted request" do
      setup do
        search_response = combined_response({
          "top-results" => [],
          "services-information" => [a_search_result("a")],
          "departments-policy" => [a_search_result("a")]
        })
        Frontend.combined_search_client.expects(:search)
            .with("glass", "sort" => "public_timestamp")
            .returns(search_response)
      end

      should "reflect the choice in the filter form" do
        get :index, q: "glass", sort: "public_timestamp"
        assert_select "input[name=sort][value='public_timestamp'][checked]"
      end

      should "remember the choice in the main search form" do
        get :index, q: "glass", sort: "public_timestamp"
        assert_select "form.search-header input[name=sort][value='public_timestamp']"
      end
    end
  end
end
