require "gds_api/test_helpers/account_api"

RSpec.describe "Cache control logging" do
  let(:log_store) { {} }

  before { allow(LogStasher).to receive(:store).and_return(log_store) }

  context "for a public cacheable response" do
    before do
      content_store_has_example_item("/national-minimum-wage-rates", schema: :answer)
      get "/national-minimum-wage-rates"
    end

    it "logs the max-age from the Content Store TTL" do
      expect(log_store[:cache_max_age]).to eq(900)
    end

    it "logs that the response is public" do
      expect(log_store[:cache_public]).to be(true)
    end
  end

  context "for a no-store response" do
    include GdsApi::TestHelpers::AccountApi

    before do
      stub_account_api_get_sign_in_url
      get "/account"
    end

    it "logs nil for max-age" do
      expect(log_store[:cache_max_age]).to be_nil
    end

    it "logs nil for the public flag" do
      expect(log_store[:cache_public]).to be_nil
    end
  end
end
