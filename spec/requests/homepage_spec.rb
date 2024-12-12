RSpec.describe "Homepage" do
  include GovukAbTesting::RspecHelpers
  include ContentStoreHelpers

  context "loading the homepage" do
    before { stub_homepage_content_item }

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
