require "gds_api/test_helpers/local_links_manager"

RSpec.describe "Local Authority API" do
  include GdsApi::TestHelpers::LocalLinksManager
  include LocationHelpers

  before { content_store_has_random_item(base_path: "/api/local-authority") }

  describe "querying" do
    it "returns a 400 if there is no query parameter" do
      get "/api/local-authority"

      expect(response).to have_http_status(:bad_request)
    end

    it "returns a 400 if the postcode is empty" do
      get "/api/local-authority?postcode="

      expect(response).to have_http_status(:bad_request)
    end

    it "returns a 400 if the postcode is invalid" do
      stub_locations_api_does_not_have_a_bad_postcode("ZZZ")
      get "/api/local-authority?postcode=ZZZ"

      expect(response).to have_http_status(:bad_request)
    end

    it "returns a 404 if the postcode is not found" do
      stub_locations_api_has_no_location("SW12 1ZZ")
      get "/api/local-authority?postcode=SW121ZZ"

      expect(response).to have_http_status(:not_found)
    end

    context "when a postcode is matched to a single authority" do
      before { configure_locations_api_and_local_authority("SW1A 1AA", %w[westminster], 5990) }

      it "redirects to the local authority" do
        get "/api/local-authority?postcode=SW1A1AA"

        expect(response).to redirect_to("/api/local-authority/westminster")
      end
    end

    context "when a postcode spans multiple authorities" do
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

      it "returns a list of addresses to choose from" do
        get "/api/local-authority?postcode=CH259BJ"

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq({
          "addresses" => [
            { "address" => "House 1", "local_authority_slug" => "achester", "local_authority_name" => "Achester" },
            { "address" => "House 2", "local_authority_slug" => "beechester", "local_authority_name" => "Beechester" },
            { "address" => "House 3", "local_authority_slug" => "ceechester", "local_authority_name" => "Ceechester" },
          ],
        })
      end
    end
  end

  describe "local authority slugs" do
    context "when the slug is not found"
    before { stub_local_links_manager_does_not_have_an_authority("foo") }

    it "returns a 404 if the slug is not found" do
      get "/api/local-authority/foo"

      expect(response).to have_http_status(:not_found)
    end

    context "when the slug points to a unitary authority" do
      before { stub_local_links_manager_has_a_local_authority("westminster") }

      it "returns the authority with no parent and tier set to unitary" do
        get "/api/local-authority/westminster"

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq({
          "local_authority" => {
            "name" => "Westminster",
            "homepage_url" => "http://westminster.example.com",
            "tier" => "unitary",
            "slug" => "westminster",
          },
        })
      end
    end

    context "when the slug points to a district authority" do
      before { stub_local_links_manager_has_a_district_and_county_local_authority("aylesbury", "buckinghamshire") }

      it "returns the authority with the parent and tier set to district" do
        get "/api/local-authority/aylesbury"

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq({
          "local_authority" => {
            "name" => "Aylesbury",
            "homepage_url" => "http://aylesbury.example.com",
            "tier" => "district",
            "slug" => "aylesbury",
            "parent" => {
              "name" => "Buckinghamshire",
              "homepage_url" => "http://buckinghamshire.example.com",
              "tier" => "county",
              "slug" => "buckinghamshire",
            },
          },
        })
      end
    end
  end
end
