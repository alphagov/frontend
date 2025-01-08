require "gds_api/test_helpers/locations_api"
require "gds_api/test_helpers/local_links_manager"
require "gds_api/test_helpers/licence_application"

RSpec.describe "Licence Transactions" do
  include GdsApi::TestHelpers::LocationsApi
  include GdsApi::TestHelpers::LocalLinksManager
  include GdsApi::TestHelpers::LicenceApplication
  include LocationHelpers

  describe "GET start" do
    before do
      content_store_has_example_item("/find-licences/new-licence", schema: "specialist_document", example: "licence-transaction")
    end

    it "sets the cache expiry headers" do
      get "/find-licences/new-licence"

      expect(response).to honour_content_store_ttl
    end
  end

  describe "POST to find" do
    before do
      payload = {
        base_path: "/find-licences/new-licence",
        document_type: "licence_transaction",
        schema_name: "specialist_document",
        title: "Licence to kill",
        public_updated_at: "2012-10-02T12:30:33.483Z",
        description: "Descriptive licence text.",
        details: {
          body: "You only live twice, Mr Bond.\n",
          metadata: {
            licence_transaction_licence_identifier: "1071-5-1",
          },
        },
      }
      stub_content_store_has_item("/find-licences/new-licence", payload)
    end

    context "when loading the licence edition and posting a location" do
      before do
        stub_licence_exists(
          "1071-5-1/00BK",
          "isLocationSpecific" => true,
          "isOfferedByCounty" => false,
          "geographicalAvailability" => %w[England Wales],
          "issuingAuthorities" => [
            {
              "authorityName" => "Staffordshire",
              "authoritySlug" => "staffordshire",
              "authorityInteractions" => {
                "apply" => [
                  {
                    "url" => "/licence-to-kill/ministry-of-love/apply-1",
                    "description" => "Apply for your Licence to kill",
                    "payment" => "none",
                    "introduction" => "",
                    "usesLicensify" => true,
                  },
                ],
              },
            },
          ],
        )
        configure_locations_api_and_local_authority("ST10 4DB", %w[staffordshire], 3435)
        post "/find-licences/new-licence/", params: { postcode: "ST10 4DB" }
      end

      it "redirects to the slug with actionable licence" do
        expect(response).to redirect_to("/find-licences/new-licence/staffordshire")
      end
    end
  end

  describe "GET authority" do
    before do
      content_store_has_example_item("/find-licences/new-licence", schema: "specialist_document", example: "licence-transaction")
    end

    it "sets the cache expiry headers" do
      get "/find-licences/new-licence/secret-service"

      expect(response).to honour_content_store_ttl
    end
  end
end
