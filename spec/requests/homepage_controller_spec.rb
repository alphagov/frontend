RSpec.describe HomepageController, type: :request do
  include GovukAbTesting::RspecHelpers

  context "loading the homepage" do
    before { stub_content_store_has_item("/", schema: "special_route") }

    it "responds with success" do
      get "/"

      expect(response).to have_http_status(:ok)
    end

    it "sets correct expiry headers" do
      get "/"

      honours_content_store_ttl
    end
  end
end
