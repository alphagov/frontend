RSpec.describe "Service Manual topic" do
  describe "GET service_manual_topic" do
    let(:content_item) { GovukSchemas::Example.find("service_manual_topic", example_name: "service_manual_topic") }
    let(:base_path) { content_item.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_item)
    end

    it "succeeds" do
      get base_path

      expect(response).to have_http_status(:ok)
    end

    it "renders the service_manual_topic template" do
      get base_path

      expect(response).to render_template(:service_manual_topic)
    end

    it "sets cache-control headers" do
      get base_path

      expect(response).to honour_content_store_ttl
    end
  end
end
