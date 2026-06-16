RSpec.describe "Topical Event Embedded About Page" do
  include GdsApi::TestHelpers::Search

  let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name: "topical-event-with-about-page") }
  let(:base_path) { "#{content_store_response.fetch('base_path')}/about" }

  before do
    stub_conditional_loader_returns_content_item_for_path(base_path, content_store_response)
    stub_request(:get, /\A#{Plek.new.find('search-api')}\/search.json/).to_return(body: { "results" => [] }.to_json)

    visit base_path
  end

  describe "basic page information" do
    it "has a page title" do
      expect(page).to have_title(content_store_response["details"]["about"]["title"])
    end

    it "has a lead paragraph taken from the summary" do
      expect(page).to have_text(content_store_response["details"]["about"]["summary"])
    end

    it "has body text" do
      expect(page).to have_text("Prime Minister Theresa May hosted the Western Balkans Summit in London on 10 July")
    end

    it "has a contents list" do
      expect(page).to have_selector(".gem-c-contents-list", text: "Contents")

      within ".gem-c-contents-list" do
        expect(page).to have_selector("a[href=\"#summit-aims\"]", text: "Summit aims")
      end
    end
  end
end
