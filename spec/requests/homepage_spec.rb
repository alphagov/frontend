RSpec.describe "Homepage" do
  include GovukAbTesting::RspecHelpers

  context "loading the homepage" do
    before do
      content_item = GovukSchemas::Example.find("homepage", example_name: "homepage_with_popular_links_on_govuk")
      base_path = content_item.fetch("base_path")
      stub_content_store_has_item(base_path, content_item)
    end

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
