RSpec.describe "FlexiblePage" do
  describe "GET show" do
    context "when visiting a Flexible page" do
      before do
        ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = "true"
        stub_const("ContentItemLoader::LOCAL_ITEMS_PATH", "spec/fixtures/local-content-items")
      end

      after do
        ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = nil
      end

      let(:base_path) { "/flexible-page" }

      it "returns 200" do
        get base_path

        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        get base_path

        expect(response).to render_template("show")
      end
    end
  end
end
