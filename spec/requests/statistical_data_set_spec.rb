RSpec.describe "Statistical Data Set" do
  let(:base_path) { "/government/statistical-data-sets/national-driving-and-riding-standards" }

  before do
    content_store_has_example_item(base_path, schema: :statistical_data_set)
  end

  describe "GET show" do
    context "when visiting a Statistical Data Set page" do
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
end
