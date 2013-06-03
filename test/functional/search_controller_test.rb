# encoding: utf-8
require "test_helper"

class SearchControllerTest < ActionController::TestCase
  def stub_client
    mainstream_client = stub("search", search: [])
    Frontend.stubs(:mainstream_search_client).returns(mainstream_client)
    detailed_client = stub("search", search: [])
    Frontend.stubs(:detailed_guidance_search_client).returns(detailed_client)
    government_client = stub("search", search: [])
    Frontend.stubs(:government_search_client).returns(government_client)
  end

  def a_search_result(slug, score)
    {
      "title" => slug.titleize,
      "description" => "Description for #{slug}",
      "link" => "/#{slug}",
      "es_score" => score
    }
  end

  setup do
    stub_client
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
    assert_select ".no-results h2", text: %Q{0 results for &ldquo;search-term&rdquo;}
  end

  test "should pass our query parameter in to the search client" do
    Frontend.mainstream_search_client.expects(:search).with("search-term", nil).returns([]).once
    get :index, q: "search-term"
  end

  test "should include link to JSON version in HTML header" do
    Frontend.mainstream_search_client.stubs(:search).returns([{}, {}, {}])
    get :index, q: "search-term"
    assert_select 'head link[rel=alternate]' do |elements|
      assert elements.any? { |element|
        element['href'] == '/api/search.json?q=search-term'
      }
    end
  end

  test "should display single result with specific class name attribute" do
    Frontend.mainstream_search_client.stubs(:search).returns([{}])
    get :index, q: "search-term"
    assert_select "div#mainstream-results.single-item-pane"
  end

  test "should display multiple results without class name for single result set" do
    Frontend.mainstream_search_client.stubs(:search).returns([{}, {}, {}])
    get :index, q: "search-term"
    assert_select "div#mainstream-results.single-item-pane", 0
  end

  test "should display just tab page of results if we have results from a single index" do
    Frontend.mainstream_search_client.stubs(:search).returns([{}, {}, {}])
    Frontend.detailed_guidance_search_client.stubs(:search).returns([])
    Frontend.government_search_client.stubs(:search).returns([])
    get :index, q: "search-term"
    assert_select 'nav.js-tabs', count: 0
  end

  test "should display tabs when there are mixed results" do
    Frontend.mainstream_search_client.stubs(:search).returns([{}, {}, {}])
    Frontend.detailed_guidance_search_client.stubs(:search).returns([{}])
    get :index, q: "search-term"
    assert_select "nav.js-tabs"
  end

  test "should display index count on respective tab" do
    Frontend.mainstream_search_client.stubs(:search).returns([{}, {}, {}])
    Frontend.detailed_guidance_search_client.stubs(:search).returns([{}])
    Frontend.government_search_client.stubs(:search).returns([{}, {}])
    get :index, q: "search-term"
    assert_select "a[href='#mainstream-results']", text: "General results (3)"
    assert_select "a[href='#detailed-results']", text: "Detailed guidance (1)"
    assert_select "a[href='#government-results']", text: "Inside Government (2)"
  end

  test "should include recommend links in the mainstream tab counts" do
    Frontend.mainstream_search_client.stubs(:search).returns(Array.new(1, {}) + Array.new(1, {format: 'recommended-link'}))
    # Need results in multiple tabs to see any tabs
    Frontend.government_search_client.stubs(:search).returns([{}])
    get :index, q: "search-term"
    assert_select "a[href='#mainstream-results']", text: "General results (2)"
  end

  test "should display a link to the documents matching our search criteria" do
    client = stub("search", search: [{"title" => "document-title", "link" => "/document-slug"}])
    Frontend.stubs(:mainstream_search_client).returns(client)
    get :index, q: "search-term"
    assert_select "a[href='/document-slug']", text: "document-title"
  end

  test "should set the class of the result according to the format" do
    client = stub("search", search: [{"title" => "title", "link" => "/slug", "highlight" => "", "format" => "publication"}])
    Frontend.stubs(:mainstream_search_client).returns(client)
    get :index, q: "search-term"
    assert_select ".results-list .type-publication"
  end

  test "should_not_blow_up_with_a_result_wihout_a_section" do
    result_without_section = {
      "title" => "TITLE1",
      "description" => "DESCRIPTION",
      "link" => "/URL"
    }
    Frontend.mainstream_search_client.stubs(:search).returns([result_without_section])
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
    Frontend.mainstream_search_client.stubs(:search).returns([result_with_section])
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
    Frontend.mainstream_search_client.stubs(:search).returns([result_with_section])
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
    Frontend.mainstream_search_client.stubs(:search).returns([result_with_section])
    get :index, {q: "bob"}

    assert_select '.meta .section', text: "Life in the UK"
    assert_select '.meta .subsection', text: 'Test thing'
    assert_select '.meta .subsubsection', text: 'Sub section'
  end

  test "should return unlimited results" do
    Frontend.mainstream_search_client.stubs(:search).returns(Array.new(75, {}))
    # Force tabs to be displayed so the selector can work
    Frontend.government_search_client.stubs(:search).returns([{}])

    get :index, q: "Test"
    assert_select "a[href='#mainstream-results']", text: "General results (75)"
  end

  test "should show the phrase searched for" do
    Frontend.mainstream_search_client.stubs(:search).returns(Array.new(75, {}))

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

    Frontend.mainstream_search_client.stubs(:search).returns([external_document])

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

    Frontend.mainstream_search_client.stubs(:search).returns([external_document])

    get :index, {q: "bleh"}
    assert_select ".recommended-links li.external" do
      assert_select "a[rel=external]", "A title"
    end
    assert_select '.internal-links li.external', count: 0
  end

  test "should show inside-government-links at the top of mainstream results" do
    normal_result = {
      "title" => "BORING",
      "description" => "DESCRIPTION",
      "link" => "/url",
      "section" => "life-in-the-uk",
      "subsection" => "test-thing"
    }
    inside_government_link = {
      "title" => "QUEUE JUMPER",
      "description" => "DESCRIPTION",
      "link" => "/government/awesome",
      "format" => "inside-government-link",
      "section" => "Inside Government"
    }

    Frontend.mainstream_search_client.stubs(:search).returns([normal_result, inside_government_link])

    get :index, { q: "bleh" }
    assert_select '#mainstream-results li:first-child a', text: "QUEUE JUMPER"
    assert_select '#mainstream-results li:nth-child(2) a', text: 'BORING'
  end

  test "should send analytics headers for citizen proposition" do
    get :index, {q: "bob"}
    assert_equal "search",  response.headers["X-Slimmer-Section"]
    assert_equal "search",  response.headers["X-Slimmer-Format"]
    assert_equal "citizen", response.headers["X-Slimmer-Proposition"]
    assert_equal "0",       response.headers["X-Slimmer-Result-Count"]
  end

  test "result count header with results" do
    Frontend.mainstream_search_client.stubs(:search).returns(Array.new(15, {}))

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

    Frontend.mainstream_search_client.stubs(:search).returns(Array.new(1, external_link))

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

  context "organisation filter" do
    should "appear on the government tab" do
      Frontend.government_search_client.stubs(:search).returns([a_search_result("c", 3)])
      get :index, { q: "moon" }
      assert_select "#government-results form#government-filter"
    end

    should "list organistions split into ministerial departments and others"

    should "retain tab parameter"

    should "let you filter results by organisation"
  end

  context "no top_result parameter" do
    should "leave the highest scored result where it is" do
      Frontend.mainstream_search_client.stubs(:search).returns([a_search_result("a", 1)])
      Frontend.detailed_guidance_search_client.stubs(:search).returns([a_search_result("b", 2)])
      Frontend.government_search_client.stubs(:search).returns([a_search_result("c", 3)])

      get :index, q: "search-term"

      assert_select "#top-results", count: 0

      assert_select "a[href='#mainstream-results']", text: "General results (1)"
      assert_select "a[href='#detailed-results']", text: "Detailed guidance (1)"
      assert_select "a[href='#government-results']", text: "Inside Government (1)"
    end
  end

  context "?top_result=1" do
    should "remove the highest scored result from the three tabs and display above all others" do
      Frontend.mainstream_search_client.stubs(:search).returns([a_search_result("a", 1)])
      Frontend.detailed_guidance_search_client.stubs(:search).returns([a_search_result("b", 2)])
      Frontend.government_search_client.stubs(:search).returns([a_search_result("c", 3)])

      get :index, q: "search-term", top_result: "1"

      assert_select "a[href='#mainstream-results']", text: "General results (1)"
      assert_select "a[href='#detailed-results']", text: "Detailed guidance (1)"
      assert_select "a[href='#government-results']", count: 0

      assert_select "#top-results a[href='/c']"
    end

    should "add a hidden field to the form so that it's retained on next search" do
      get :index, q: "search-term", top_result: "1"
      assert_select "#content form[role=search] input[name=top_result][value=1]"
    end
  end

  context "?combine=1" do
    should "merge mainstream and detailed results in one tab" do
      Frontend.mainstream_search_client.stubs(:search).returns([{ "es_score" => 1 }, { "es_score" => 1 }, { "es_score" => 1 }])
      Frontend.detailed_guidance_search_client.stubs(:search).returns([{ "es_score" => 1 }])
      Frontend.government_search_client.stubs(:search).returns([{}, {}])
      get :index, { q: "tax", combine: "1" }
      assert_select "a[href='#services-information-results']", text: "Services, information and guidance (4)"
      assert_select "a[href='#government-results']", text: "Policies, departments and announcements (2)"
    end

    should "correctly sort the merged mainstream and detailed results" do
      Frontend.mainstream_search_client.stubs(:search).returns([a_search_result("high", 10)])
      Frontend.detailed_guidance_search_client.stubs(:search).returns([a_search_result("low", 5)])
      get :index, { q: "tax", combine: "1" }
      assert_select 'li:first-child  h3 a[href=/high]'
      assert_select 'li:nth-child(2) h3 a[href=/low]'
    end

    should "hackily downweight detailed results to prevent them from swamping better mainstream results" do
      Frontend.mainstream_search_client.stubs(:search).returns([a_search_result("mainstream", 100)])
      Frontend.detailed_guidance_search_client.stubs(:search).returns([a_search_result("detailed", 101)])
      get :index, { q: "tax", combine: "1" }
      assert_select 'li:first-child  h3 a[href=/mainstream]'
      assert_select 'li:nth-child(2) h3 a[href=/detailed]'
    end
  end
end
