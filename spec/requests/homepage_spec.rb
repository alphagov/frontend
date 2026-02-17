RSpec.describe "Homepage" do
  include GovukAbTesting::RspecHelpers
  include ContentStoreHelpers

  context "when loading the homepage" do
    before { stub_homepage_content_item }

    it "responds with success" do
      get "/"

      expect(response).to have_http_status(:ok)
    end

    it "sets correct expiry headers" do
      get "/"

      expect(response).to honour_content_store_ttl
    end

    it "does not set Vary headers" do
      get "/"

      expect(response.headers["Vary"]).to be_nil
    end
  end
end
