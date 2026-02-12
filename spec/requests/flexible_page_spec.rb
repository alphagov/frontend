RSpec.describe "FlexiblePage" do
  describe "GET show" do
    let(:base_path) { "/flexible-page" }

    before do
      ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = "true"
      stub_const("ContentItemLoaders::LocalFileLoader::LOCAL_ITEMS_PATH", "spec/fixtures/local-content-items")
      get base_path
    end

    after do
      ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = nil
    end

    it "returns 200" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      expect(response).to render_template("show")
    end
  end
end
