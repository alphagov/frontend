RSpec.describe "Detailed Guide" do
  before do
    content_store_has_example_item("/guidance/salary-sacrifice-and-the-effects-on-paye", schema: :detailed_guide)
  end

  describe "GET show" do
    it "returns 200" do
      get "/guidance/salary-sacrifice-and-the-effects-on-paye"

      expect(response).to have_http_status(:ok)
    end
  end
end
