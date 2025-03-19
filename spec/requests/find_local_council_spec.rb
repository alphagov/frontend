require "gds_api/test_helpers/local_links_manager"

RSpec.describe "Find Local Council" do
  include GdsApi::TestHelpers::LocalLinksManager
  include LocationHelpers

  before { content_store_has_random_item(base_path: "/find-local-council") }

  it "sets correct expiry headers" do
    get "/find-local-council"

    expect(response).to honour_content_store_ttl
  end

  it "returns a 404 if the local authority can't be found" do
    stub_local_links_manager_does_not_have_an_authority("foo")
    get "/find-local-council/foo"

    expect(response).to have_http_status(:not_found)
  end

  context "when querying as JSON" do
    before do
      configure_locations_api_and_local_authority("SW1A 1AA", %w[westminster], 5990)
    end

    it "redirects to the authority slug" do
      get "/find-local-council.json", params: { postcode: "SW1A 1AA" }

      expect(response).to redirect_to("/find-local-council/westminster.json")
    end

    it "returns local authority JSON" do
      get "/find-local-council/westminster.json"
      expected_json =
        {
          "local_authority" => {
            "name" => "Westminster",
            "homepage_url" => "http://westminster.example.com",
            "tier" => "unitary",
            "slug" => "westminster",
          },
        }
      expect(response.parsed_body).to eq(expected_json)
    end
  end
end
