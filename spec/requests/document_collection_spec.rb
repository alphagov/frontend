RSpec.describe "Document Collection" do
  let(:base_path) { "/government/collections/national-driving-and-riding-standards" }

  before do
    content_store_has_example_item(base_path, schema: :document_collection)
  end

  describe "GET show" do
    context "when visiting a Document Collection page" do
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

  describe "Vary headers" do
    it "sets GOVUK-Account-Session-Flash in the Vary header" do
      get base_path

      expect(response.headers["Vary"]).to include("GOVUK-Account-Session-Flash")
    end
  end
end
