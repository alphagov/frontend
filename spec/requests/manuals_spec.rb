RSpec.describe "Manuals" do
  before do
    stub_content_store_does_not_have_item("/guidance")
    content_store_has_example_item("/guidance/content-design", schema: :manual, example: "content-design")
  end

  describe "GET show" do
    it "shows the manual page" do
      get "/guidance/content-design"

      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      get "/guidance/content-design"

      expect(response).to render_template("show")
    end
  end
end
