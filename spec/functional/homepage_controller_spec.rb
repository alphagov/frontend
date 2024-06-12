RSpec.describe HomepageController, type: :controller do
  include GovukAbTesting::RspecHelpers

  context "loading the homepage" do
    before { stub_content_store_has_item("/", schema: "special_route") }

    it "responds with success" do
      get(:index)

      assert_response(:success)
    end

    it "sets correct expiry headers" do
      get(:index)

      honours_content_store_ttl
    end
  end
end
