RSpec.describe "Topical event about page" do
  describe "GET show" do
    let(:content_item) { GovukSchemas::Example.find("topical_event_about_page", example_name: "topical_event_about_page") }
    let(:base_path) { content_item.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_item)
    end

    it "succeeds" do
      get base_path

      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      get base_path

      expect(response).to render_template(:show)
    end
  end
end
