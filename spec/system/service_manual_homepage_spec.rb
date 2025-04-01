RSpec.describe "Service Manual homepage" do
  describe "GET /<document_type>/<slug>" do
    let(:content_store_response) { GovukSchemas::Example.find("service_manual_homepage", example_name: "service_manual_homepage") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
    end

    it "displays the page" do
      visit base_path

      expect(page.status_code).to eq(200)
    end

    it "displays the introductory text" do
      visit base_path

      expect(page).to have_text("Helping teams to create and run great public services that meet the Service Standard.")
    end

    it "has a feedback link" do
      visit base_path

      expect(page).to have_text("Contact the Service Manual team with any comments or questions.")
      within(".gem-c-inverse-header") do
        expect(page).to have_link("Contact the Service Manual team", href: "/service-manual/communities/contact-the-service-manual-and-service-standard-team")
      end
    end

    it "includes GA4 form tracking on the search form" do
      visit base_path

      expect(page).to have_css("[data-module='ga4-form-tracker']")
      expect(page).to have_css("[data-ga4-form='{\"event_name\": \"search\", \"type\": \"content\", \"url\": \"/search/all\", \"section\": \"Service Manual\", \"action\": \"search\"}']")
      expect(page).to have_css("[data-ga4-form-include-text]")
      expect(page).to have_css("[data-ga4-form-no-answer-undefined]")
    end

    it "scopes the search to the service manual" do
      visit base_path

      within("form[action='/search']") do
        expect(page).to have_css("input[type='hidden'][value='/service-manual']", visible: :hidden)
      end
    end

    it "shows the titles and descriptions of associated topics" do
      visit base_path

      expect(page).to have_text(content_store_response["links"]["children"][0]["title"])
      expect(page).to have_text(content_store_response["links"]["children"][0]["description"])
      expect(page).to have_link(content_store_response["links"]["children"][0]["title"], href: content_store_response["links"]["children"][0]["base_path"])
    end

    it "includes a link to the service standard" do
      visit base_path

      expect(page).to have_text("The Service Standard provides the principles of building a good service. This manual explains what teams can do to build great services that will meet the standard.")
      expect(page).to have_link("Service Standard", href: "/service-manual/service-standard")
    end

    it "includes a link to the communities of practise" do
      visit base_path

      expect(page).to have_text("You can view the communities of practice to find more learning resources, see who has written the guidance in the manual and connect with digital people like you from across government.")
      expect(page).to have_link("communities of practice", href: "/service-manual/communities")
    end
  end
end
