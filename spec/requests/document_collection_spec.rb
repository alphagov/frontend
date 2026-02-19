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

      it_behaves_like "it supports personalisation cache headers"
    end
  end
end
