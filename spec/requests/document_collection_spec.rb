RSpec.describe "Document Collection" do
  let(:base_path) { "/government/collections/national-driving-and-riding-standards" }

  before do
    content_store_has_example_item(base_path, schema: :document_collection)
    get base_path
  end

  describe "GET show" do
    it "returns 200" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      expect(response).to render_template("show")
    end

    it_behaves_like "it supports personalisation cache headers"

    context "when requesting a non-english version of a page" do
      let(:base_path) { "/government/collections/national-driving-and-riding-standards.hi" }

      it "succeeds" do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
