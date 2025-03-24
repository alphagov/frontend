require "gds_api/test_helpers/local_links_manager"

RSpec.describe "Find Local Council" do
  include GdsApi::TestHelpers::LocalLinksManager
  include LocationHelpers

  before { content_store_has_random_item(base_path: "/find-local-council") }

  it "sets correct expiry headers" do
    get "/find-local-council"

    expect(response).to honour_content_store_ttl
  end

  context "when the local authority can't be found" do
    before { stub_local_links_manager_does_not_have_an_authority("foo") }

    it "returns a 404 to an HTML request" do
      get "/find-local-council/foo"

      expect(response).to have_http_status(:not_found)
    end

    it "returns a 404 to a JSON request" do
      get "/find-local-council/foo.json"

      expect(response).to have_http_status(:not_found)
    end
  end

  context "with a postcode that has multiple local authorities" do
    before do
      stub_locations_api_has_location(
        "CH25 9BJ",
        [
          { "address" => "House 1", "local_custodian_code" => "1" },
          { "address" => "House 2", "local_custodian_code" => "2" },
          { "address" => "House 3", "local_custodian_code" => "3" },
        ],
      )
      stub_local_links_manager_has_a_local_authority("achester", local_custodian_code: 1)
      stub_local_links_manager_has_a_local_authority("beechester", local_custodian_code: 2)
      stub_local_links_manager_has_a_local_authority("ceechester", local_custodian_code: 3)
    end

    it "responds with 200 and returns the address choices to a JSON request" do
      get "/find-local-council/query.json", params: { postcode: "CH25 9BJ" }

      expected_json = {
        "addresses" => [
          { "address" => "House 1", "slug" => "achester", "name" => "Achester" },
          { "address" => "House 2", "slug" => "beechester", "name" => "Beechester" },
          { "address" => "House 3", "slug" => "ceechester", "name" => "Ceechester" },
        ],
      }
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq(expected_json)
    end
  end

  context "when the authority exists" do
    before do
      configure_locations_api_and_local_authority("SW1A 1AA", %w[westminster], 5990)
    end

    it "responds with 200 to an HTML request" do
      get "/find-local-council/westminster"

      expect(response).to have_http_status(:ok)
    end

    it "responds with 200 and returns local authority JSON to a JSON request" do
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
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq(expected_json)
    end

    it "redirects a valid postcode query to the authority slug" do
      get "/find-local-council/query.json", params: { postcode: "SW1A 1AA" }

      expect(response).to redirect_to("/find-local-council/westminster.json")
    end

    context "when the postcode is not found" do
      before { stub_locations_api_has_no_location("NO1 1HR") }

      it "responds with 404 to a postcode query" do
        get "/find-local-council/query.json", params: { postcode: "NO1 1HR" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
