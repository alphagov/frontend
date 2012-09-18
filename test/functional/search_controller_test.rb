# encoding: utf-8
require "test_helper"

class SearchControllerTest < ActionController::TestCase
  def stub_both_clients
    client = stub("search", search: [])
    Frontend.stubs(:mainstream_search_client).returns(client)
    Frontend.stubs(:specialist_search_client).returns(client)
  end

  test "should ask the user to enter a search term if none was given" do
    stub_both_clients
    get :index, q: ""
    assert_select "label", %{What are you looking for?}
    assert_select "form[action=?]", search_path do
      assert_select "input[name=q]"
    end
  end

  test "should inform the user that we didn't find any documents matching the search term" do
    stub_both_clients
    get :index, q: "search-term"
    assert_select "p", text: %Q{Please try another search in the search box at the top of the page.}
  end

  test "should pass our query parameter in to the search client" do
    client = stub("search")
    Frontend.stubs(:mainstream_search_client).returns(client)
    Frontend.stubs(:specialist_search_client).returns(client)
    client.stubs(:search).returns([])
    client.expects(:search).with("search-term", nil).returns([]).once
    get :index, q: "search-term"
  end

  test "should display the number of results" do
    client = stub("search", search: [{}, {}, {}])
    Frontend.stubs(:mainstream_search_client).returns(client)
    Frontend.stubs(:specialist_search_client).returns(client)
    get :index, q: "search-term"
    assert_select "span.result-count", text: /3/
  end

  test "should display a link to the documents matching our search criteria" do
    client = stub("search", search: [{"title" => "document-title", "link" => "/document-slug"}])
    Frontend.stubs(:mainstream_search_client).returns(client)
    Frontend.stubs(:specialist_search_client).returns(client)
    get :index, q: "search-term"
    assert_select "a[href='/document-slug']", text: "document-title"
  end

  test "should set the class of the result according to the format" do
    client = stub("search", search: [{"title" => "title", "link" => "/slug", "highlight" => "", "format" => "publication"}])
    Frontend.stubs(:mainstream_search_client).returns(client)
    Frontend.stubs(:specialist_search_client).returns(client)
    get :index, q: "search-term"
    assert_select ".results-list .type-publication"
  end

  test "should_not_blow_up_with_a_result_wihout_a_section" do
    stub_both_clients

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

  # test "should not allow xss vulnerabilites as search terms" do
  #   stub_both_clients

  #   get :index, {q: "1+\"><script+src%3Dhttp%3A%2F%2F88.151.219.231%2F4><%2Fscript>"}

  #   assert_match "Sorry, we can’t find any results for", response.body
  #   assert_match "\"1+&quot;&gt;&lt;script+src%3Dhttp%3A%2F%2F88.151.219.231%2F4&gt;&lt;%2Fscript&gt;\"", response.body
  # end

  # test "should_not_show_secondary_solr_guidance_filter_when_no_secondary_solr_results_present" do
  #   @primary_solr.stubs(:search).returns([sample_document, sample_document])
  #   @secondary_solr.stubs(:search).returns([])

  #   get "/search", {q: "1.21 gigawatts?!"}

  #   assert last_response.ok?
  #   assert_response_text "2 results"
  #   assert_equal false, last_response.body.include?("Specialist guidance")
  # end

  # test "should_show_secondary_solr_guidance_filter_when_secondary_solr_results_exist" do
  #   settings.stubs(:feature_flags).returns({:use_secondary_solr_index => true})

  #   @primary_solr.stubs(:search).returns([sample_document])
  #   @secondary_solr.stubs(:search).returns([sample_document])

  #   get "/search", {q: "Are you telling me that you built a time machine... out of a DeLorean?"}

  #   assert last_response.ok?
  #   assert_equal true, last_response.body.include?("Specialist guidance")
  # end

  # test "should_include_secondary_solr_results_when_provided_results_count" do
  #   settings.stubs(:feature_flags).returns({:use_secondary_solr_index => true})

  #   @primary_solr.stubs(:search).returns([sample_document])
  #   @secondary_solr.stubs(:search).returns([sample_document])

  #   get "/search", {q: "If my calculations are correct, when this baby hits 88 miles per hour... you're gonna see some serious shit."}

  #   assert last_response.ok?
  #   assert_response_text "2 results"
  # end

  # test "should_show_secondary_solr_results_count_next_to_secondary_solr_filter" do
  #   settings.stubs(:feature_flags).returns({:use_secondary_solr_index => true})

  #   @primary_solr.stubs(:search).returns([sample_document])
  #   @secondary_solr.stubs(:search).returns([sample_document])

  #   get "/search", {q: "This is heavy."}

  #   assert last_response.ok?
  #   assert_match "Specialist guidance <span>1</span>", last_response.body
  # end

  # test "should_show_secondary_solr_results_after_the_primary_solr_results" do
  #   settings.stubs(:feature_flags).returns({:use_secondary_solr_index => true})

  #   example_secondary_solr_result = {
  #     "title" => "Back to the Future",
  #     "description" => "In 1985, Doc Brown invents time travel; in 1955, Marty McFly accidentally prevents his parents from meeting, putting his own existence at stake.",
  #     "format" => "local_transaction",
  #     "section" => "de-lorean",
  #     "link" => "/1-21-gigawatts"
  #   }

  #   @primary_solr.stubs(:search).returns([sample_document])
  #   @secondary_solr.stubs(:search).returns([Document.from_hash(example_secondary_solr_result)])

  #   get "/search", {q: "Hey, Doc, we better back up. We don't have enough road to get up to 88.\nRoads? Where we're going, we don't need roads"}

  #   assert last_response.ok?
  #   assert_match "<li class=\"section-specialist type-local_transaction\">", last_response.body
  #   assert_match "<p class=\"search-result-title\"><a href=\"/1-21-gigawatts\" title=\"View Back to the Future\">Back to the Future</a></p>", last_response.body
  #   assert_match "<p>In 1985, Doc Brown invents time travel; in 1955, Marty McFly accidentally prevents his parents from meeting, putting his own existence at stake.</p>", last_response.body
  #   assert_match "<a href=\"/browse/de-lorean\">De lorean</a><", last_response.body
  # end

  test "should limit results" do
    main_client = stub("search")
    second_client = stub("other_search")
    Frontend.stubs(:mainstream_search_client).returns(main_client)
    Frontend.stubs(:specialist_search_client).returns(second_client)
    main_client.stubs(:search).returns(Array.new(75, {}))
    second_client.stubs(:search).returns([])

    get :index, q: "Test"

    assert_equal 50, assigns[:results].length
    assert_equal 0, assigns[:secondary_results].length
  end

  test "should only show limited main and limited secondary results" do
    main_client = stub("search")
    second_client = stub("other_search")
    Frontend.stubs(:mainstream_search_client).returns(main_client)
    Frontend.stubs(:specialist_search_client).returns(second_client)
    main_client.stubs(:search).returns(Array.new(52, {}))
    second_client.stubs(:search).returns(Array.new(7, {}))

    get :index, q: "Test"

    assert_equal 45, assigns[:results].length
    assert_equal 5, assigns[:secondary_results].length
  end

  test "should_show_external_links_with_a_separate_list_class" do
    external_document = {
      "title" => "A title",
      "description" => "This is a description",
      "format" => "recommended-link",
      "link" => "http://twitter.com",
      "section" => "driving"
    }

    stub_both_clients
    Frontend.mainstream_search_client.stubs(:search).returns([external_document])
    
    get :index, {q: "bleh"}
    assert_select "li.external" do
      assert_select "a[rel=external]", "A title"
    end
  end

  test "we pass the optional filter parameter to searches" do
    client = stub("search", search: [])
    Frontend.stubs(:mainstream_search_client).returns(client)
    Frontend.stubs(:specialist_search_client).returns(client)
    client.expects(:search).with("anything", "my-format").returns([])

    get :index, {q: "anything", format_filter: "my-format"}
  end
end
