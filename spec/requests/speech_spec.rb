RSpec.describe "Speech" do
  before do
    content_store_has_example_item("/government/speeches/vehicle-regulations", schema: :speech)
  end

  describe "GET index" do
    it "returns 200" do
      get "/government/speeches/vehicle-regulations"

      expect(response).to have_http_status(:ok)
    end
  end
end
