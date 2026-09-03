RSpec.describe "Working Group" do
  let(:content_item) { GovukSchemas::Example.find("working_group", example_name: "long") }
  let(:base_path) { content_item.fetch("base_path") }

  before do
    stub_content_store_has_item(base_path, content_item)
  end

  describe "GET show" do
    it "returns 200" do
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
