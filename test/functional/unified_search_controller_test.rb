# encoding: utf-8
require "test_helper"

class UnifiedSearchControllerTest < ActionController::TestCase

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
      "index" => "government",
      "organisations" => [
        {
          "acronym" => acronym,
          "title" => title,
          "slug" => slug,
         }
      ]
    }
  end

  def stub_results(results, query = "search-term", organisations = [])
    response_body = response(results)
    parameters = {
      :start => nil,
      :count => '50',
      :q => query,
      :filter_organisations => organisations,
      :facet_organisations => '100',
    }
    Frontend.search_client.stubs(:unified_search)
        .with(parameters)
        .returns(response_body)
  end

  def expect_search_client_is_requested(organisations, query = "search-term")
    parameters = {
      :start => nil,
      :count => '50',
      :q => query,
      :filter_organisations => organisations,
      :facet_organisations => '100',
    }
    Frontend.search_client.expects(:unified_search)
        .with(parameters)
        .returns(response([]))
  end

  def stub_single_result(result)
    stub_results([result])
  end

  def response(results)
    response_body = {
      "results" => results,
      "total" => results.count,
      "facets" => {
        "organisations" =>
          {
            "options" =>
              [
                {"value" =>
                  {
                    "slug" => "ministry-of-silly-walks",
                    "link" => "/government/organisations/ministry-of-silly-walks",
                    "title" => "Ministry of Silly Walks",
                    "acronym" => "MOSW",
                    "organisation_type" => "Ministerial department",
                    "organisation_state" => "live"
                  },
                  "documents"=>12
                }
              ],
            "documents_with_no_value"=>1619,
            "total_options"=>139,
            "missing_options"=>39,
          }
        }
      }
  end

  def no_results
    response([])
  end

  setup do
    @controller = SearchController.new
    stub_results([])
  end

  test "should ask the user to enter a search term if none was given" do
    get :unified, { q: "", ui: "unified" }
    assert_select "label", %{Search GOV.UK}
    assert_select "form[action=?]", search_path do
      assert_select "input[name=q]"
    end
  end

  test "should inform the user that we didn't find any documents matching the search term" do
    stub_results([])
    get :unified, { q: "search-term", ui: "unified" }
    assert_select ".no-results h2", text: %Q{No results for &ldquo;search-term&rdquo;}
  end

  test "should pass our query parameter in to the search client" do
    stub_results([])
    get :unified, q: "search-term", ui: "unified"
  end

  test "should display a link to the documents matching our search criteria" do
    result = {"title" => "document-title", "link" => "/document-slug"}
    stub_single_result(result)
    get :unified, {q: "search-term", ui: "unified"}
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
    get :unified, { q: "search-term", ui: "unified" }

    assert_select ".results-list .type-publication"
  end

  test "should_not_blow_up_with_a_result_wihout_a_section" do
    result_without_section = {
      "title" => "TITLE1",
      "description" => "DESCRIPTION",
      "link" => "/URL"
    }
    stub_results([result_without_section], "bob")
    assert_nothing_raised do
      get :unified, { q: "bob", ui: "unified" }
    end
  end

  test "should include sections in results" do
    result_with_section = {
      "title" => "TITLE1",
      "description" => "DESCRIPTION",
      "link" => "/url",
      "section" => "life-in-the-uk"
    }
    stub_results([result_with_section], "bob")
    get :unified, {q: "bob", ui: "unified"}

    assert_select ".meta .section", text: "Life in the UK"
  end

  test "should include sub-sections in results" do
    result_with_section = {
      "title" => "TITLE1",
      "description" => "DESCRIPTION",
      "link" => "/url",
      "section" => "life-in-the-uk",
      "subsection" => "test-thing"
    }
    stub_results([result_with_section], "bob")
    get :unified, {q: "bob", ui: "unified"}

    assert_select ".meta .section", text: "Life in the UK"
    assert_select ".meta .subsection", text: "Test thing"
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
    stub_results([result_with_section], "bob")
    get :unified, {q: "bob", ui: "unified"}

    assert_select ".meta .section", text: "Life in the UK"
    assert_select ".meta .subsection", text: "Test thing"
    assert_select ".meta .subsubsection", text: "Sub section"
  end

  should "include organisations where available" do
    result = result_with_organisation("CO", "Cabinet Office", "cabinet-office")
    stub_results([result], "bob")
    get :unified, { q: "bob" , ui: "unified"}

    assert_select "ul.attributes li", /CO/
  end

  should "provide an abbr tag to explain organisation abbreviations" do
    result = result_with_organisation("CO", "Cabinet Office", "cabinet-office")
    stub_results([result], "bob")
    get :unified, { q: "bob" , ui: "unified"}

    assert_select "ul.attributes li abbr[title='Cabinet Office']", text: "CO"
  end

  should "not provide an abbr tag when the organisation title is the acronym" do
    result = result_with_organisation("Home Office", "Home Office", "home-office")
    stub_results([result], "bob")
    get :unified, { q: "bob" , ui: "unified"}

    assert_select "ul.attributes li abbr[title='Home Office']", count: 0
    assert_select "ul.attributes li", /Home Office/
  end

  should "filter by organisation" do
    expect_search_client_is_requested(['ministry-of-silly-walks'])
    get :unified, {q: "search-term", ui: "unified", filter_organisations: ["ministry-of-silly-walks"]}
  end

  should "filter by multiple organisations" do
    expect_search_client_is_requested(['ministry-of-silly-walks', 'ministry-of-beer'])
    get :unified, {q: "search-term", ui: "unified", filter_organisations: ["ministry-of-silly-walks", "ministry-of-beer"]}
  end

  test "should return unlimited results" do
    results = []
    75.times do |n|
      results << a_search_result("result-#{n}")
    end
    stub_results(results, "Test")

    get :unified, {q: "Test", ui: "unified"}
    assert_select "#unified-results h3 a", count: 75
  end

  test "should show the phrase searched for" do
    stub_results(Array.new(75, {}), "Test")

    get :unified, q: "Test", ui: "unified"

    assert_select "input[value=Test]"
  end

  test "should_show_external_links_with_a_separate_list_class" do
    external_document = {
      "title" => "A title",
      "description" => "This is a description",
      "link" => "http://twitter.com",
      "section" => "driving",
      "format" => "recommended-link"
    }

    stub_results([external_document], "bleh")

    get :unified, {q: "bleh", ui: "unified"}
    assert_select "li.external" do
      assert_select "a[rel=external]", "A title"
    end
  end

  test "should send analytics headers for citizen proposition" do
    result = {
      "title" => "title",
      "link" => "/slug",
      "highlight" => "",
      "format" => "publication"
    }
    stub_results([result], "bob")
    get :unified, {q: "bob", ui: "unified"}
    assert_equal "search",  @response.headers["X-Slimmer-Section"]
    assert_equal "search",  @response.headers["X-Slimmer-Format"]
    assert_equal "citizen", @response.headers["X-Slimmer-Proposition"]
    assert_equal "1",       @response.headers["X-Slimmer-Result-Count"]
  end

  test "display the total number of results" do
    stub_results(Array.new(15, {}), "bob")

    get :unified, {q: "bob", ui: "unified"}

    assert_equal "15", @response.headers["X-Slimmer-Result-Count"]
  end

  test "truncate long external URLs to a fixed length" do
    external_link = {
      "title" => "A title",
      "description" => "This is a description",
      "link" => "http://www.weally.weally.long.url.com/weaseling/about/the/world",
      "section" => "driving",
      "format" => "recommended-link"
    }
    stub_results([external_link], "bleh")

    get :unified, {q: "bleh", ui: "unified"}

    assert_response :success
    assert_select "li.type-guide.external .meta" do
      assert_select ".url", {count: 1, text: "www.weally.weally.long.url.com/weaseling/abou..."}
    end
  end

  test "should remove the scheme from external URLs" do
    external_link = {
      "title" => "A title",
      "description" => "This is a description",
      "link" => "http://www.badgers.com/badgers",
      "format" => "recommended-link"
    }
    stub_results([external_link], "bleh")

    get :unified, {q: "bleh", ui: "unified"}

    assert_response :success
    assert_select "li.type-guide.external .meta" do
      assert_select ".url", {count: 1, text: "www.badgers.com/badgers"}
    end
  end

  test "should remove the scheme from HTTPS URLs" do
    external_link = {
      "title" => "A title",
      "description" => "This is a description",
      "link" => "https://www.badgers.com/badgers",
      "format" => "recommended-link"
    }
    stub_results([external_link], "bleh")

    get :unified, {q: "bleh", ui: "unified"}

    assert_response :success
    assert_select "li.type-guide.external .meta" do
      assert_select ".url", {count: 1, text: "www.badgers.com/badgers"}
    end
  end

  test "should handle service errors with a 503" do
    Frontend.search_client.stubs(:unified_search).raises(GdsApi::BaseError)
    get :unified, {q: "badness", ui: "unified"}

    assert_response 503
  end
end
