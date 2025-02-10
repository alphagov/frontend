RSpec.describe "Specialist Document" do
  describe "GET show" do
    let(:content_item) { GovukSchemas::Example.find("specialist_document", example_name: "aaib-reports") }
    let(:finder_content_item) { GovukSchemas::Example.find("specialist_document", example_name: "aaib-reports") }
    let(:base_path) { content_item.fetch("base_path") }
    let(:finder_base_path) { content_item.dig("links", "finder", 0, "base_path") }

    before do
      stub_content_store_has_item(base_path, content_item)
      stub_content_store_has_item(finder_base_path)
    end

    it "succeeds" do
      get base_path

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
