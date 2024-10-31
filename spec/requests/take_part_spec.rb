RSpec.describe "Take Part" do
  before do
    content_store_has_example_item("/government/get-involved/take-part/tp1", schema: :take_part)
  end

  context "GET index" do
    it "returns 200" do
      get "/government/get-involved/take-part/tp1"

      expect(response).to have_http_status(:ok)
    end
  end
end
