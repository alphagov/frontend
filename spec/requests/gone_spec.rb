RSpec.describe "Gone" do
  describe "GET index" do
    let(:base_path) { "/foreign-travel-advice/grand-fenwick" }

    before do
      stub_content_store_has_item(base_path, schema_name: "gone")
    end

    it "redirects the gone item to the gone controller" do
      get "/foreign-travel-advice/grand-fenwick"

      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      get base_path

      expect(response).to render_template(:show)
    end

    it "sets cache-control headers" do
      get base_path

      expect(response).to honour_content_store_ttl
    end
  end
end
