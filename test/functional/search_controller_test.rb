# encoding: utf-8
require "test_helper"
require "json"

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

  def rummager_result_fields
    %w{
      description
      display_type
      document_series
      format
      last_update
      link
      organisations
      organisation_state
      public_timestamp
      section
      slug
      specialist_sectors
      subsection
      subsubsection
      title
      topics
      world_locations
    }
  end

  def stub_results(results, query = "search-term", organisations = [], suggestions = [], options = {})
    response_body = response(results, suggestions, options)
    Frontend.search_client.stubs(:search)
        .returns(response_body)
  end

  def expect_search_client_is_requested(organisations, query = "search-term", options = {})
    parameters = {
      :start => options[:start] || '0',
      :count => options[:count] || '50',
      :q => query,
      :filter_organisations => organisations,
      :fields => rummager_result_fields,
      :facet_organisations => '100',
      :debug => nil,
    }
    if options[:specialist_sectors]
      parameters[:filter_specialist_sectors] = options[:specialist_sectors]
      parameters[:facet_specialist_sectors] = "100"
    end
    Frontend.search_client.expects(:search)
        .returns(response([]))
  end

  def stub_single_result(result)
    stub_results([result])
  end

  def response(results, suggestions=[], options={})
    {
      "results" => results,
      "total" => results.count,
      "facets" => {
        "organisations" => {
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
      },
      "suggested_queries" => suggestions,
      "total" => options[:total] || 200,
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
    get :index, { q: "" }
    assert_select "label", %{Search GOV.UK}
    assert_select "form[action=?]", search_path do
      assert_select "input[name=q]"
    end
  end

  test "should not raise an error responding to a json request with no search term" do
    stub_results([], '')
    assert_nothing_raised do
      get :index, { q: "", format: :json }
    end
  end

  test "should inform the user that we didn't find any documents matching the search term" do
    stub_results([])
    get :index, { q: "search-term" }
    assert_select ".zero-results h2"
  end

  test "should pass our query parameter in to the search client" do
    stub_results([])
    get :index, q: "search-term"
  end

  test "should display a link to the documents matching our search criteria" do
    result = {"title" => "document-title", "link" => "/document-slug"}
    stub_single_result(result)
    get :index, {q: "search-term"}
    assert_select "a[href='/document-slug']", text: "document-title"
  end

  test "should_not_blow_up_with_a_result_wihout_a_section" do
    result_without_section = {
      "title" => "TITLE1",
      "description" => "DESCRIPTION",
      "link" => "/URL"
    }
    stub_results([result_without_section], "bob")
    assert_nothing_raised do
      get :index, { q: "bob" }
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
    get :index, {q: "bob"}

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
    get :index, {q: "bob"}

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
    get :index, {q: "bob"}

    assert_select ".meta .section", text: "Life in the UK"
    assert_select ".meta .subsection", text: "Test thing"
    assert_select ".meta .subsubsection", text: "Sub section"
  end

  should "include organisations where available" do
    result = result_with_organisation("CO", "Cabinet Office", "cabinet-office")
    stub_results([result], "bob")
    get :index, { q: "bob" }

    assert_select "ul.attributes li", /CO/
  end

  should "provide an abbr tag to explain organisation abbreviations" do
    result = result_with_organisation("CO", "Cabinet Office", "cabinet-office")
    stub_results([result], "bob")
    get :index, { q: "bob" }

    assert_select "ul.attributes li abbr[title='Cabinet Office']", text: "CO"
  end

  should "not provide an abbr tag when the organisation title is the acronym" do
    result = result_with_organisation("Home Office", "Home Office", "home-office")
    stub_results([result], "bob")
    get :index, { q: "bob" }

    assert_select "ul.attributes li abbr[title='Home Office']", count: 0
    assert_select "ul.attributes li", /Home Office/
  end

  should "filter by organisation" do
    expect_search_client_is_requested(['ministry-of-silly-walks'])
    get :index, {q: "search-term", filter_organisations: ["ministry-of-silly-walks"]}
  end

  should "filter by multiple organisations" do
    expect_search_client_is_requested(['ministry-of-silly-walks', 'ministry-of-beer'])
    get :index, {q: "search-term", filter_organisations: ["ministry-of-silly-walks", "ministry-of-beer"]}
  end

  should "filter by topic (using specialist_sectors internal field)" do
    expect_search_client_is_requested([], "a query",
      specialist_sectors: ["business-tax/vat"],
    )
    get :index, {q: "a query", filter_topics: ["business-tax/vat"]}
  end

  should "suggest the first alternative query" do
    suggestions = ["cats","dogs"]
    results = [ a_search_result('something') ]

    stub_results(results, "search-term", [], suggestions)

    get :index, q: "search-term"
    assert_select ".spelling-suggestion", text: "Did you mean cats"
  end

  should "preserve filters when suggesting spellings" do
    suggestions = ["cats"]
    results = [ a_search_result('something') ]

    stub_results(results, "search-term", ["hm-revenue-customs"], suggestions)

    get :index, q: "search-term", filter_organisations: ["hm-revenue-customs"]
    assert_select ".spelling-suggestion", text: "Did you mean cats"
    assert_select %{.spelling-suggestion a[href*="filter_organisations%5B%5D=hm-revenue-customs"]}
  end


  test "should return unlimited results" do
    results = []
    75.times do |n|
      results << a_search_result("result-#{n}")
    end
    stub_results(results, "Test")

    get :index, {q: "Test"}
    assert_select "#results h3 a", count: 75
  end

  test "should show the phrase searched for" do
    stub_results(Array.new(75, {}), "Test")

    get :index, q: "Test"

    assert_select "input[value=Test]"
  end

  test 'should link to the next page' do
    stub_results(Array.new(50, {}), 'Test', [], [], total: 100)

    get :index, q: 'Test'

    assert_select 'li.next', /Next page/
    assert_select 'li.next', /2 of 2/
  end

  test 'should link to the previous page' do
    stub_results(Array.new(50, {}), 'Test', [], [], start: '50', total: 100)

    get :index, q: 'Test', start: 50

    assert_select 'li.previous', /Previous page/
    assert_select 'li.previous', /1 of 2/
  end

  test 'should default to 0 given a negative start parameter' do
    expect_search_client_is_requested([], 'Test', start: '0')

    get :index, q: 'Test', start: -1
  end

  test 'should default to 50 given a negative count parameter' do
    expect_search_client_is_requested([], 'Test', count: '50')

    get :index, q: 'Test', count: -1
  end

  test 'should default to 50 given a zero count parameter' do
    expect_search_client_is_requested([], 'Test', count: '50')

    get :index, q: 'Test', count: -1
  end

  test 'should request at most 100 results' do
    expect_search_client_is_requested([], 'Test', count: '100')

    get :index, q: 'Test', count: 1000
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

    get :index, {q: "bleh"}
    assert_select "li.external" do
      assert_select "a[rel=external]", "A title"
    end
  end

  test "should send analytics headers" do
    result = {
      "title" => "title",
      "link" => "/slug",
      "highlight" => "",
      "format" => "publication"
    }
    stub_results([result], "bob", [], [], total: 1)
    get :index, {q: "bob"}
    assert_equal "search",  @response.headers["X-Slimmer-Section"]
    assert_equal "search",  @response.headers["X-Slimmer-Format"]
    assert_equal "1",       @response.headers["X-Slimmer-Result-Count"]
  end

  test "display the total number of results" do
    stub_results(Array.new(15, {}), "bob", [], [], total: 15)

    get :index, {q: "bob"}

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

    get :index, {q: "bleh"}

    assert_response :success
    assert_select "li.external .meta" do
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

    get :index, {q: "bleh"}

    assert_response :success
    assert_select "li.external .meta" do
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

    get :index, {q: "bleh"}

    assert_response :success
    assert_select "li.external .meta" do
      assert_select ".url", {count: 1, text: "www.badgers.com/badgers"}
    end
  end

  test "should handle service errors with a 503" do
    Frontend.search_client.stubs(:search).raises(GdsApi::BaseError)
    get :index, {q: "badness"}

    assert_response 503
  end

  test "should render json results" do
    stub_results(Array.new(15, {}), "bob", [], [], total: 15)
    get :index, { q: "bob", format: "json" }

    json = JSON.parse(@response.body)
    assert_equal json["result_count"], 15
    assert_equal json["result_count_string"], "15 results"
    assert_equal json["results"].length, 15
  end

  test "should render json with no results" do
    stub_results(Array.new(0, {}), "bob", [], [], total: 0)
    get :index, { q: "bob", format: "json" }

    json = JSON.parse(@response.body)
    assert_equal json["result_count"], 0
    assert_equal json["results"].length, 0
  end
end
