RSpec.describe "Calls for evidence document" do
  describe "GET show" do
    let(:content_item) { GovukSchemas::Example.find("call_for_evidence", example_name: "call_for_evidence_outcome") }
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
