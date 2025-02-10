RSpec.describe "Detailed Guide" do
  before do
    content_store_has_example_item("/guidance/salary-sacrifice-and-the-effects-on-paye", schema: :detailed_guide)
  end

  describe "GET show" do
    let(:base_path) { "/guidance/salary-sacrifice-and-the-effects-on-paye" }

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
