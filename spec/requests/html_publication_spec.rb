RSpec.describe "HTML publication" do
  describe "GET show" do
    let(:content_item) { GovukSchemas::Example.find("html_publication", example_name: "long_form_and_automatically_numbered_headings") }
    let(:base_path) { content_item.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_item)
      parent_path = content_item["links"]["parent"].first["base_path"]
      stub_content_store_has_item(parent_path, GovukSchemas::Example.find("publication", example_name: "publication"))
    end

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
