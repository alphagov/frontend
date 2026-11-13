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

      vary = response.headers["Vary"].to_s.split(/,\s*/).map(&:downcase)

      expect(vary - %w[x-requested-with]).to be_empty
    end
  end
end
