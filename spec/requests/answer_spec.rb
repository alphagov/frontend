RSpec.describe "Answer" do
  before do
    content_store_has_example_item("/gwasanaethau-ar-lein-cymraeg-cthem", schema: :answer)
  end

  describe "GET show" do
    context "when visting answer page" do
      let(:base_path) { "/gwasanaethau-ar-lein-cymraeg-cthem" }

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
