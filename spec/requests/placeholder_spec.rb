RSpec.describe "Placeholder" do
  context "when loading the placeholder page" do
    it "responds with success" do
      stub_content_store_does_not_have_item("/government")
      stub_content_store_does_not_have_item("/government/placeholder")
      get "/government/placeholder"

      expect(response).to have_http_status(:ok)
    end
  end
end
