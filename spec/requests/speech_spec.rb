RSpec.describe "Speech" do
  before do
    content_store_has_example_item("/government/speeches/vehicle-regulations", schema: :speech)
  end

  describe "GET show" do
    context "when visiting a Speech page" do
      let(:base_path) { "/government/speeches/vehicle-regulations" }

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
