# encoding: utf-8
require "test_helper"
require "json"

class SearchControllerTest < ActionController::TestCase
  def a_search_result(slug, score = 1)
    {
      "title_with_highlighting" => slug.titleize,
      "description_with_highlighting" => "Description for #{slug}",
      "link" => "/#{slug}",
      "es_score" => score
    }
  end

  def result_with_organisation(acronym, title, slug)
    {
      "title_with_highlighting" => "Something by #{title}",
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
      description_with_highlighting
      display_type
      document_series
      format
      government_name
      is_historic
      link
      organisations
      organisation_state
      public_timestamp
      slug
      specialist_sectors
      title_with_highlighting
      world_locations
    }
  end

  def stub_results(results, query = "search-term", organisations = [], suggestions = [], options = {})
    response_body = response(results, suggestions, options)
    SearchAPI.stubs(:new).returns(stub(search: response_body))
  end

  def stub_single_result(result)
    stub_results([result])
  end

  def response(results, suggestions = [], options = {})
    {
      "results" => results,
      "facets" => {
        "organisations" => {
          "options" =>
            [
              { "value" =>
                {
                  "slug" => "ministry-of-silly-walks",
                  "link" => "/government/organisations/ministry-of-silly-walks",
                  "title" => "Ministry of Silly Walks",
                  "acronym" => "MOSW",
                  "organisation_type" => "Ministerial department",
                  "organisation_state" => "live"
                },
                "documents" => 12
              }
            ],
          "documents_with_no_value" => 1619,
          "total_options" => 139,
          "missing_options" => 39,
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
    get :index, q: ""
    assert_select "label", %{Search GOV.UK}
    assert_select "form[action=?]", search_path do
      assert_select "input[name=q]"
    end
  end

  test "should not raise an error responding to a json request with no search term" do
    stub_results([], '')
    assert_nothing_raised do
      get :index, q: "", format: :json
    end
  end

  test "should inform the user that we didn't find any documents matching the search term" do
    stub_results([])
    get :index, q: "search-term"
    assert_select ".zero-results h2"
  end

  test "should pass our query parameter in to the search client" do
    stub_results([])
    get :index, q: "search-term"
  end

  test "should display a link to the documents matching our search criteria" do
    result = { "title_with_highlighting" => "document-title", "link" => "/document-slug" }
    stub_single_result(result)
    get :index, q: "search-term"
    assert_select "a[href='/document-slug']", text: "document-title"
  end

  test "should apply history mode to historic result" do
    historic_result = {
      "title_with_highlighting" => "TITLE1",
      "description_with_highlighting" => "DESCRIPTION",
      "is_historic" => true,
      "government_name" => "XXXX to YYYY Example government",
      "link" => "/url",
      "index" => "government"
    }

    stub_results([historic_result], "bob")
    get :index, q: "bob"

    assert_select ".historic", text: /XXXX to YYYY Example government/
  end

  test "should not apply history mode to non historic result" do
    historic_result = {
      "title_with_highlighting" => "TITLE1",
      "description_with_highlighting" => "DESCRIPTION",
      "is_historic" => false,
      "government_name" => nil,
      "link" => "/url",
      "index" => "government"
    }

    stub_results([historic_result], "bob")
    get :index, q: "bob"

    assert_select ".historic", 0
  end

  test "should not apply history mode to historic result without government name" do
    historic_result = {
      "title_with_highlighting" => "TITLE1",
      "description_with_highlighting" => "DESCRIPTION",
      "is_historic" => true,
      "government_name" => nil,
      "link" => "/url",
      "index" => "government"
    }

    stub_results([historic_result], "bob")
    get :index, q: "bob"

    assert_select ".historic", 0
  end

  should "include organisations where available" do
    result = result_with_organisation("CO", "Cabinet Office", "cabinet-office")
    stub_results([result], "bob")
    get :index, q: "bob"

    assert_select "ul.attributes li", /CO/
  end

  should "provide an abbr tag to explain organisation abbreviations" do
    result = result_with_organisation("CO", "Cabinet Office", "cabinet-office")
    stub_results([result], "bob")
    get :index, q: "bob"

    assert_select "ul.attributes li abbr[title='Cabinet Office']", text: "CO"
  end

  should "not provide an abbr tag when the organisation title is the acronym" do
    result = result_with_organisation("Home Office", "Home Office", "home-office")
    stub_results([result], "bob")
    get :index, q: "bob"

    assert_select "ul.attributes li abbr[title='Home Office']", count: 0
    assert_select "ul.attributes li", /Home Office/
  end

  should "suggest the first alternative query" do
    suggestions = ["cats", "dogs"]
    results = [a_search_result('something')]

    stub_results(results, "search-term", [], suggestions)

    get :index, q: "search-term"
    assert_select ".spelling-suggestion", text: "Did you mean cats"
  end

  should "preserve filters when suggesting spellings" do
    suggestions = ["cats"]
    results = [a_search_result('something')]

    stub_results(results, "search-term", ["hm-revenue-customs"], suggestions)

    get :index, q: "search-term", filter_organisations: ["hm-revenue-customs"]
    assert_select ".spelling-suggestion", text: "Did you mean cats"
    assert_select %{.spelling-suggestion a[href*="filter_organisations%5B%5D=hm-revenue-customs"]}
  end

  should "display the filters box as open when searching with a filter" do
    results = [a_search_result('something')]

    stub_results(results, "search-term", ["hm-revenue-customs"])

    get :index, q: "search-term", filter_organisations: ["hm-revenue-customs"]
    assert_select ".filter-form .filter.closed", count: 0
  end

  should "display the filters box as open when searching from whitehall" do
    results = [a_search_result('something')]

    stub_results(results, "search-term")

    get :index, q: "search-term", show_organisations_filter: "true"
    assert_select ".filter-form .filter.closed", count: 0
  end

  should "display the filters box as closed when searching from sources other than whitehall" do
    results = [a_search_result('something')]

    stub_results(results, "search-term")

    get :index, q: "search-term"
    assert_select ".filter-form .filter:not(.closed)", count: 0
  end


  test "should return unlimited results" do
    results = []
    75.times do |n|
      results << a_search_result("result-#{n}")
    end
    stub_results(results, "Test")

    get :index, q: "Test"
    assert_select "#results h3 a", count: 75
  end

  test "should show the phrase searched for" do
    stub_results(Array.new(75, {}), "Test")

    get :index, q: "Test"

    assert_select "input[value=Test]"
  end

  test 'should link to the next page' do
    stub_results(Array.new(50, {}), 'Test', [], [], total: 100)

    get :index, q: 'Test', count: 50

    assert_select 'li.next', /Next page/
    assert_select 'li.next', /2 of 2/
  end

  test 'should link to the previous page' do
    stub_results(Array.new(50, {}), 'Test', [], [], start: '50', total: 100)

    get :index, q: 'Test', start: 50, count: 50

    assert_select 'li.previous', /Previous page/
    assert_select 'li.previous', /1 of 2/
  end

  test "should_show_external_links_with_rel_external" do
    external_document = {
      "title_with_highlighting" => "A title",
      "description_with_highlighting" => "This is a description",
      "link" => "http://twitter.com",
      "section" => "driving",
      "format" => "recommended-link"
    }

    stub_results([external_document], "bleh")

    get :index, q: "bleh"
    assert_select ".results-list li" do
      assert_select "a[rel=external]", "A title"
    end
  end

  test "should send analytics headers" do
    result = {
      "title_with_highlighting" => "title",
      "link" => "/slug",
      "highlight" => "",
      "format" => "publication"
    }
    stub_results([result], "bob", [], [], total: 1)
    get :index, q: "bob"
    assert_equal "search",  @response.headers["X-Slimmer-Section"]
    assert_equal "search",  @response.headers["X-Slimmer-Format"]
    assert_equal "1",       @response.headers["X-Slimmer-Result-Count"]
  end

  test "display the total number of results" do
    stub_results(Array.new(15, {}), "bob", [], [], total: 15)

    get :index, q: "bob"

    assert_equal "15", @response.headers["X-Slimmer-Result-Count"]
  end

  test "truncate long external URLs to a fixed length" do
    external_link = {
      "title_with_highlighting" => "A title",
      "description_with_highlighting" => "This is a description",
      "link" => "http://www.weally.weally.long.url.com/weaseling/about/the/world",
      "section" => "driving",
      "format" => "recommended-link"
    }
    stub_results([external_link], "bleh")

    get :index, q: "bleh"

    assert_response :success
    assert_select ".results-list li .meta" do
      assert_select ".url", count: 1, text: "www.weally.weally.long.url.com/weaseling/abou..."
    end
  end

  test "should remove the scheme from external URLs" do
    external_link = {
      "title_with_highlighting" => "A title",
      "description_with_highlighting" => "This is a description",
      "link" => "http://www.badgers.com/badgers",
      "format" => "recommended-link"
    }
    stub_results([external_link], "bleh")

    get :index, q: "bleh"

    assert_response :success
    assert_select ".results-list li .meta" do
      assert_select ".url", count: 1, text: "www.badgers.com/badgers"
    end
  end

  test "should remove the scheme from HTTPS URLs" do
    external_link = {
      "title_with_highlighting" => "A title",
      "description_with_highlighting" => "This is a description",
      "link" => "https://www.badgers.com/badgers",
      "format" => "recommended-link"
    }
    stub_results([external_link], "bleh")

    get :index, q: "bleh"

    assert_response :success
    assert_select ".results-list li .meta" do
      assert_select ".url", count: 1, text: "www.badgers.com/badgers"
    end
  end

  test "should handle service errors with a 503" do
    SearchAPI.stubs(:new).raises(GdsApi::BaseError)
    get :index, q: "badness"

    assert_response 503
  end

  test "should render json results" do
    stub_results(Array.new(15, {}), "bob", [], [], total: 15)
    get :index, q: "bob", format: "json"

    json = JSON.parse(@response.body)
    assert_equal json["result_count"], 15
    assert_equal json["result_count_string"], "15 results"
    assert_equal json["results"].length, 15
  end

  test "should render json with no results" do
    stub_results(Array.new(0, {}), "bob", [], [], total: 0)
    get :index, q: "bob", format: "json"

    json = JSON.parse(@response.body)
    assert_equal json["result_count"], 0
    assert_equal json["results"].length, 0
  end

  test "should track the search homepage as a 'finding' page type" do
    get :index

    assert_select "meta[name='govuk:user-journey-stage'][content='finding']", 1
  end

  test "should track the search results page as a 'finding' page type" do
    get :index, q: "some search term"

    assert_select "meta[name='govuk:user-journey-stage'][content='finding']", 1
  end
end
