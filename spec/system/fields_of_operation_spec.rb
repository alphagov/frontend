RSpec.describe "Fields of operation page" do
  describe "GET /<document_type>/<slug>" do
    let(:content_store_response) { GovukSchemas::Example.find("fields_of_operation", example_name: "fields_of_operation") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "displays the page" do
      expect(page.status_code).to eq(200)
    end

    it "has the correct title" do
      expect(page.title).to eq("Fields of operation - GOV.UK")
    end
  end
end
