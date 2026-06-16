RSpec.describe "Topical event about page" do
  include GdsApi::TestHelpers::Search

  describe "GET show" do
    let(:content_item) { GovukSchemas::Example.find("topical_event_about_page", example_name: "topical_event_about_page") }
    let(:base_path) { content_item.fetch("base_path") }

    before do
      stub_conditional_loader_returns_content_item_for_path(base_path, content_item)
      stub_request(:get, /\A#{Plek.new.find('search-api')}\/search.json/).to_return(body: { "results" => [] }.to_json)

      get base_path
    end

    it "succeeds" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end

    context "when the about information is embedded within a topical event content item" do
      let(:content_item) { GovukSchemas::Example.find("topical_event", example_name: "topical-event-with-about-page") }
      let(:base_path) { "#{content_item.fetch('base_path')}/about" }

      it "succeeds" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        expect(response).to render_template("topical_event/about")
      end
    end
  end
end
