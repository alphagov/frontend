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

    it "renders webchat widget with correct data attributes" do
      expect(page).to have_selector("[data-module='webchat'][data-availability-url='https://d1y02qp19gjy8q.cloudfront.net/availability/18555309']")
      expect(page).to have_selector("[data-module='webchat'][data-open-url='https://d1y02qp19gjy8q.cloudfront.net/open/index.html']")
      expect(page).to have_selector("[data-module='webchat'][data-redirect='false']")
    end

    it "sets the correct content security policy for webchat hosts" do
      parsed_csp = parse_csp_header(page.response_headers["Content-Security-Policy"])

      expect(parsed_csp["connect-src"]).to include("https://d1y02qp19gjy8q.cloudfront.net")
    end

    it "has GA4 tracking on the webchat available link" do
      expected_ga4_data = '{"event_name":"navigation","type":"webchat","text":"Speak to an adviser now"}'

      expect(page).to have_selector(".js-webchat-advisers-available a[data-module=ga4-link-tracker]")
      expect(page).to have_selector(".js-webchat-advisers-available a[data-ga4-link='#{expected_ga4_data}']")
    end
  end

private

  def parse_csp_header(csp_header)
    csp_header.split(";")
              .map { |directive| directive.strip.split(" ") }
              .each_with_object({}) { |directive, memo| memo[directive.first] = directive[1..] }
  end
end
