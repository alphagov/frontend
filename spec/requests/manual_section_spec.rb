RSpec.describe "Manual Section" do
  describe "GET section" do
    context "when a manual section exists" do
      let(:content_item) { GovukSchemas::Example.find("manual_section", example_name: "what-is-content-design") }
      let(:base_path) { content_item.fetch("base_path") }

      before do
        stub_content_store_has_item(base_path, content_item)
        manual_content_item = GovukSchemas::Example.find("manual", example_name: "content-design")
        stub_content_store_has_item(manual_content_item.fetch("base_path"), manual_content_item)
      end

      it "succeeds" do
        get base_path

        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        get base_path

        expect(response).to render_template(:section)
      end
    end
  end
end
