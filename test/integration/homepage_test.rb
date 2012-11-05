require_relative "../integration_test_helper"

class HomepageTest < ActionDispatch::IntegrationTest
  should "show a root section generated from the Content API" do
    hash_response = {
      "_response_info" => {"status" => "ok"},
      "description" => "Tags!",
      "total" => 1,
      "start_index" => 1, "page_size" => 1,
      "current_page" => 1,
      "pages" => 1,
      "results" => [{"title" => "Crime and justice",
                      "id" => "https://in-your-government.uk/tags/crime-and-justice.json",
                      "web_url" => nil,
                      "details" => {
                        "description" => "Bleh",
                        "short_description" => "ASBOs, prisons, Jokers and Batman",
                        "type" => "section"},
                      "content_with_tag" => {
                        "id" => "https://in-your-government.uk/with_tag.json?tag=crime-and-justice",
                        "web_url" => "https://in-your-government.uk/browse/crime-and-justice"},
                      "parent" => nil}]}
    mocked = mock("response")
    mocked.expects(:to_hash).once.returns(hash_response)
    GdsApi::ContentApi.any_instance.expects(:root_sections).once.returns(mocked)

    visit "/"

    assert page.has_selector?("ul.categories-list li", :count => 1)

    within("ul.categories-list li") do
      assert page.has_content?("Crime and justice")
      assert page.has_content?("ASBOs, prisons, Jokers and Batman")
    end
  end
end
