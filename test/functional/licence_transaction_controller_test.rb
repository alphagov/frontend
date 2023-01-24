require "test_helper"
require "gds_api/test_helpers/locations_api"
require "gds_api/test_helpers/local_links_manager"
require "gds_api/test_helpers/licence_application"

class LicenceTransactionControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::LocationsApi
  include GdsApi::TestHelpers::LocalLinksManager
  include GdsApi::TestHelpers::LicenceApplication
  include LocationHelpers

  context "GET start" do
    context "for live content" do
      setup do
        content_store_has_example_item(
          "/find-licences/new-licence", schema: "specialist_document", example: "licence-transaction"
        )
      end

      should "set the cache expiry headers" do
        get :start, params: { slug: "new-licence" }

        honours_content_store_ttl
      end
    end
  end

  context "POST to find" do
    setup do
      @payload = {
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

      stub_content_store_has_item("/find-licences/new-licence", @payload)
    end

    context "loading the licence edition when posting a location" do
      setup do
        stub_licence_exists(
          "1071-5-1",
          "isLocationSpecific" => true,
          "isOfferedByCounty" => false,
          "geographicalAvailability" => %w[England Wales],
          "issuingAuthorities" => [],
        )
      end

      context "for an English local authority" do
        setup do
          configure_locations_api_and_local_authority("ST10 4DB", %w[staffordshire staffordshire-moorlands], 3435)

          post :find, params: { slug: "new-licence", postcode: "ST10 4DB" }
        end

        should "redirect to the slug for the lowest level authority" do
          assert_redirected_to "/find-licences/new-licence/staffordshire-moorlands"
        end
      end

      context "for a Northern Irish local authority" do
        setup do
          configure_locations_api_and_local_authority("BT1 5GS", %w[belfast], 8132)

          post :find, params: { slug: "new-licence", postcode: "BT1 5GS" }
        end

        should "redirect to the slug for the lowest level authority" do
          assert_redirected_to "/find-licences/new-licence/belfast"
        end
      end
    end
  end

  context "GET authority" do
    context "for live content" do
      setup do
        content_store_has_example_item(
          "/find-licences/new-licence", schema: "specialist_document", example: "licence-transaction"
        )
      end

      should "set the cache expiry headers" do
        get :authority, params: { slug: "new-licence", authority_slug: "secret-service" }

        honours_content_store_ttl
      end
    end
  end
end
