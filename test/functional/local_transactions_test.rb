require 'test_helper'

require 'gds_api/part_methods'
require 'gds_api/test_helpers/mapit'

class LocalTransactionsTest < ActionController::TestCase

  tests RootController
  include GdsApi::TestHelpers::Mapit

  context "given a local transaction exists in content api" do
    setup do
      @artefact = {
        "title" => "Send a bear to your local council",
        "format" => "local_transaction",
        "web_url" => "http://example.org/send-a-bear-to-your-local-council",
        "details" => {
          "format" => "LocalTransaction",
          "local_service" => {
            "description" => "What could go wrong?",
            "lgsl_code" => "8342",
            "providing_tier" => [ "district", "unitary" ]
          }
        }
      }

      content_api_has_an_artefact('send-a-bear-to-your-local-council', @artefact)
    end

    context "loading the local transaction edition without any location" do
      should "return the normal content for a page" do
        get :publication, slug: "send-a-bear-to-your-local-council"

        assert_response :success
        assert_equal assigns(:publication).title, "Send a bear to your local council"
      end

      should "set correct expiry headers" do
        get :publication, slug: "send-a-bear-to-your-local-council"

        assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
      end
    end

    context "loading the local transaction when posting a location" do
      context "for an English local authority" do
        setup do
          mapit_has_a_postcode_and_areas("ST10 4DB", [0, 0], [
            { "name" => "Staffordshire County Council", "type" => "CTY", "ons" => "41"},
            { "name" => "Staffordshire Moorlands District Council", "type" => "DIS", "ons" => "41UH"},
            { "name" => "Cheadle and Checkley", "type" => "CED" }
          ])

          post :publication, slug: "send-a-bear-to-your-local-council", postcode: "ST10 4DB"
        end

        should "redirect to the slug for the appropriate authority tier" do
          assert_redirected_to "/send-a-bear-to-your-local-council/staffordshire-moorlands"
        end
      end
    end

    context "loading the local transaction for an authority" do
      setup do
        artefact_with_interaction = @artefact.dup
        artefact_with_interaction["details"].merge!({
          "local_interaction" => {
            "lgsl_code" => 461,
            "lgil_code" => 8,
            "url" => "http://www.staffsmoorlands.gov.uk/sm/council-services/parks-and-open-spaces/parks"
          },
          "local_authority" => {
            "name" => "Staffordshire Moorlands",
            "contact_details" => [
              "Moorlands House",
              "Stockwell Street",
              "Leek",
              "Staffordshire",
              "ST13 6HQ"
            ],
            "contact_url" => "http://www.staffsmoorlands.gov.uk/sm/contact-us"
          }
        })

        content_api_has_an_artefact_with_snac_code('send-a-bear-to-your-local-council', "41UH", artefact_with_interaction)
      end

      should "assign local transaction information" do
        get :publication, slug: "send-a-bear-to-your-local-council", part: "staffordshire-moorlands"

        assert_equal "http://www.staffsmoorlands.gov.uk/sm/council-services/parks-and-open-spaces/parks", assigns(:local_transaction_details)["local_interaction"]["url"]
      end
    end

    should "return a 404 for an incorrect authority slug" do
      get :publication, slug: "send-a-bear-to-your-local-council", part: "this slug should not exist"

      assert_equal 404, response.status
    end
  end

  context "given a local transaction without an interaction exists in content api" do
    setup do
      @artefact = {
        "title" => "Report a bear on a local road",
        "format" => "local_transaction",
        "web_url" => "http://example.org/report-a-bear-on-a-local-road",
        "details" => {
          "format" => "LocalTransaction",
          "local_service" => {
            "description" => "Contact your council to dispatch Cousin Sven's bear enforcement squad in your area.",
            "lgsl_code" => "1234",
            "providing_tier" => [ "district", "unitary" ]
          },
          "local_interaction" => nil,
          "local_authority" => {
            "name" => "Staffordshire Moorlands",
            "contact_details" => [
              "Moorlands House",
              "Stockwell Street",
              "Leek",
              "Staffordshire",
              "ST13 6HQ"
            ],
            "contact_url" => "http://www.staffsmoorlands.gov.uk/sm/contact-us"
          }
        }
      }

      content_api_has_an_artefact('report-a-bear-on-a-local-road', @artefact)
      content_api_has_an_artefact_with_snac_code('report-a-bear-on-a-local-road', "41UH", @artefact)
    end

    should "show error message" do
      get :publication, slug: "report-a-bear-on-a-local-road", part: "staffordshire-moorlands"

      assert response.ok?
      assert response.body.include?("application-notice help-notice")
    end
  end
end
