RSpec.describe "Placeholder" do
  context "when loading the placeholder page" do
    it "responds with success" do
      stub_conditional_loader_does_not_return_content_item_for_path("/government")
      stub_conditional_loader_does_not_return_content_item_for_path("/government/placeholder")
      get "/government/placeholder"

      expect(response).to have_http_status(:ok)
    end
  end
end
