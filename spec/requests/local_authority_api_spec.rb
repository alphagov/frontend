require "gds_api/test_helpers/local_links_manager"

RSpec.describe "Local Authority API" do
  include GdsApi::TestHelpers::LocalLinksManager

  before { content_store_has_random_item(base_path: "/api/local-authority") }

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
