# encoding: utf-8
require "test_helper"

class SearchControllerTest < ActionController::TestCase
  def stub_client
    mainstream_client = stub("search", search: [])
    Frontend.stubs(:mainstream_search_client).returns(mainstream_client)
  end

  setup do
    stub_client
  end

  test "should ask the user to enter a search term if none was given" do
    get :index, q: ""
    assert_select "label", %{What are you looking for?}
    assert_select "form[action=?]", search_path do
      assert_select "input[name=q]"
    end
  end

  test "should inform the user that we didn't find any documents matching the search term" do
    get :index, q: "search-term"
    assert_select "p", text: %Q{Please try another search in the search box at the top of the page.}
  end

  test "should pass our query parameter in to the search client" do
    Frontend.mainstream_search_client.expects(:search).with("search-term", nil).returns([]).once
    get :index, q: "search-term"
  end

  test "should display the number of results" do
    Frontend.mainstream_search_client.stubs(:search).returns([{}, {}, {}])
    get :index, q: "search-term"
    assert_select "label", text: /3 results found/
  end

  test "should use correct pluralisation for a single result" do
    Frontend.mainstream_search_client.stubs(:search).returns([{}])
    get :index, q: "search-term"
    assert_select "label", text: /1 result found/
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
      "format" => "local_transaction",
      "link" => "/URL"
    }
    Frontend.mainstream_search_client.stubs(:search).returns([result_without_section])
    assert_nothing_raised do
      get :index, {q: "bob"}
    end
  end

  test "should limit results" do
    Frontend.mainstream_search_client.stubs(:search).returns(Array.new(75, {}))

    get :index, q: "Test"

    assert_equal 50, assigns[:results].length
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
      "format" => "recommended-link",
      "link" => "http://twitter.com",
      "section" => "driving"
    }

    Frontend.mainstream_search_client.stubs(:search).returns([external_document])
    
    get :index, {q: "bleh"}
    assert_select "li.external" do
      assert_select "a[rel=external]", "A title"
    end
  end

  test "we pass the optional filter parameter to searches" do
    Frontend.mainstream_search_client.expects(:search).with("anything", "my-format").returns([])

    get :index, {q: "anything", format_filter: "my-format"}
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
end
