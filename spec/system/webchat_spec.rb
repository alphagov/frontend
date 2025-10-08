RSpec.describe "Webchat" do
  let(:content_store_response) do
    {
      "base_path" => base_path,
      "title" => "Test Webchat",
      "links" => {
        "ordered_related_items" => [
          {
            "title" => "Test Quick Link",
            "url" => "/test-link",
            "schema_name" => "answer",
          },
        ],
        "parent" => [
          {
            "title" => "Test Parent Organization",
            "base_path" => "/test-parent",
            "schema_name" => "organisation",
          },
        ],
      },
      "description" => "Chat online with Test Organization advisers",
      "schema_name" => "special_route",
    }
  end
  let(:base_path) { "/government/organisations/hm-passport-office/contact/hm-passport-office-webchat" }

  context "when visiting the webchat path" do
    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "renders webchat page with title and content" do
      expect(page).to have_selector("h1", text: "Test Webchat")
      expect(page).to have_content("Advisers may be busy at peak times")
    end
  end

#   test "renders webchat widget with correct data attributes" do
#     visit WEBCHAT_PATH

#     assert_selector ".js-webchat[data-availability-url='https://webchat.host/available']"
#     assert_selector ".js-webchat[data-open-url='https://webchat.host/open']"
#     assert_selector ".js-webchat[data-redirect='false']"
#   end

#   test "does not render with the single page notification button" do
#     visit WEBCHAT_PATH
#     assert_no_selector ".single-page-notification-button"
#   end

#   test "the content security policy is updated for webchat hosts" do
#     Capybara.current_driver = :rack_test

#     visit WEBCHAT_PATH
#     parsed_csp = parse_csp_header(page.response_headers["Content-Security-Policy"])

#     assert_includes parsed_csp["connect-src"], "https://webchat.host"
#   end

#   test "has GA4 tracking on the webchat available link" do
#     visit WEBCHAT_PATH
#     assert_ga4_tracking_present
#   end

# private

#   def parse_csp_header(csp_header)
#     csp_header.split(";")
#               .map { |directive| directive.strip.split(" ") }
#               .each_with_object({}) { |directive, memo| memo[directive.first] = directive[1..] }
#   end

#   def assert_ga4_tracking_present
#     assert_selector ".js-webchat-advisers-available a[data-module=ga4-link-tracker]"
#     assert_selector ".js-webchat-advisers-available a[data-ga4-link='#{expected_ga4_data}']"
#   end

#   def expected_ga4_data
#     '{"event_name":"navigation","type":"webchat","text":"Speak to an adviser now"}'
#   end
end
