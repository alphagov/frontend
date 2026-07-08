RSpec.describe "History" do
  describe "GET show" do
    let(:content_item) { GovukSchemas::Example.find("history", example_name: "history") }
    let(:base_path) { content_item.fetch("base_path") }

    before do
      stub_conditional_loader_returns_content_item_for_path(base_path, content_item)

      get base_path
    end

    it "succeeds" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end

    it "sets cache-control headers" do
      expect(response).to honour_content_store_ttl
    end
  end
end
