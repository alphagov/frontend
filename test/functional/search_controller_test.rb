require "test_helper"

class SearchControllerTest < ActionController::TestCase
  test "should ask the user to enter a search term if none was given" do
    client = stub("search", search: [])
    Frontend.stubs(:search_client).returns(client)
    get :index, q: ""
    assert_select "label", %{What are you looking for?}
    assert_select "form[action=?]", search_path do
      assert_select "input[name=q]"
    end
  end

  test "should inform the user that we didn't find any documents matching the search term" do
    client = stub("search", search: [])
    Frontend.stubs(:search_client).returns(client)
    get :index, q: "search-term"
    assert_select "p", text: %Q{Please try another search in the search box at the top of the page.}
  end

  test "should pass our query parameter in to the search client" do
    client = stub("search")
    Frontend.stubs(:search_client).returns(client)
    client.expects(:search).with("search-term").returns([])
    get :index, q: "search-term"
  end

  test "should display the number of results" do
    client = stub("search", search: [{}, {}, {}])
    Frontend.stubs(:search_client).returns(client)
    get :index, q: "search-term"
    assert_select "span.result-count", text: /3/
  end

  test "should display a link to the documents matching our search criteria" do
    client = stub("search", search: [{"title" => "document-title", "link" => "/document-slug"}])
    Frontend.stubs(:search_client).returns(client)
    get :index, q: "search-term"
    assert_select "a[href='/document-slug']", text: "document-title"
  end

  test "should set the class of the result according to the format" do
    client = stub("search", search: [{"title" => "title", "link" => "/slug", "highlight" => "", "format" => "publication"}])
    Frontend.stubs(:search_client).returns(client)
    get :index, q: "search-term"
    assert_select ".results-list .type-publication"
  end
end
