RSpec.describe "HRMC Manual Section" do
  describe "GET section" do
    context "when an HMRC manual section exists" do
      let(:content_item) { GovukSchemas::Example.find("hmrc_manual_section", example_name: "vatgpb2000") }
      let(:base_path) { content_item.fetch("base_path") }

      before do
        stub_content_store_has_item(base_path, content_item)

        get base_path
      end

      it "succeeds" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        expect(response).to render_template(:section)
      end

      it "renders using the application layout" do
        expect(response).to render_template("layouts/application")
      end
    end
  end
end
