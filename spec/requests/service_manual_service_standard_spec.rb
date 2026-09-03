RSpec.describe "Service manual service standard page" do
  describe "GET index" do
    let(:content_item) { GovukSchemas::Example.find("service_manual_service_standard", example_name: "service_manual_service_standard") }
    let(:base_path) { content_item.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_item)
    end

    it "succeeds" do
      get base_path

      expect(response).to have_http_status(:ok)
    end

    it "renders the service_standard template" do
      get base_path

      expect(response).to render_template(:service_standard)
    end

    it "sets cache-control headers" do
      get base_path

      expect(response).to honour_content_store_ttl
    end
  end
end
