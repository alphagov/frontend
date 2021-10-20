require "test_helper"
require "gds_api/test_helpers/mapit"
require "gds_api/test_helpers/licence_application"

class LicenceControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::LicenceApplication

  context "GET start" do
    context "for live content" do
      setup do
        content_store_has_page("licence-to-kill")
      end

      should "set the cache expiry headers" do
        get :start, params: { slug: "licence-to-kill" }

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end
  end

  context "POST to start" do
    setup do
      @payload = {
        base_path: "/licence-to-kill",
        document_type: "licence",
        format: "licence",
        schema_name: "licence",
        title: "Licence to kill",
        public_updated_at: "2012-10-02T12:30:33.483Z",
        description: "Descriptive licence text.",
        details: {
          licence_identifier: "1071-5-1",
          licence_overview: "You only live twice, Mr Bond.\n",
        },
      }

      stub_content_store_has_item("/licence-to-kill", @payload)
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
          stub_mapit_has_a_postcode_and_areas(
            "ST10 4DB",
            [0, 0],
            [
              { "name" => "Staffordshire County Council", "type" => "CTY", "ons" => "41", "govuk_slug" => "staffordshire-county" },
              { "name" => "Staffordshire Moorlands District Council", "type" => "DIS", "ons" => "41UH", "govuk_slug" => "staffordshire-moorlands" },
              { "name" => "Cheadle and Checkley", "type" => "CED" },
            ],
          )

          post :start, params: { slug: "licence-to-kill", postcode: "ST10 4DB" }
        end

        should "redirect to the slug for the lowest level authority" do
          assert_redirected_to "/licence-to-kill/staffordshire-moorlands"
        end
      end

      context "for a Northern Irish local authority" do
        setup do
          stub_mapit_has_a_postcode_and_areas(
            "BT1 5GS",
            [0, 0],
            [
              { "name" => "Belfast City Council", "type" => "LGD", "ons" => "N09000003", "govuk_slug" => "belfast" },
              { "name" => "Shaftesbury", "type" => "LGW", "ons" => "95Z24" },
            ],
          )

          post :start, params: { slug: "licence-to-kill", postcode: "BT1 5GS" }
        end

        should "redirect to the slug for the lowest level authority" do
          assert_redirected_to "/licence-to-kill/belfast"
        end
      end
    end
  end

  context "GET authority" do
    context "for live content with a licence which exists" do
      setup do
        stub_content_store_has_item("/licence-to-kill", {
          base_path: "/licence-to-kill",
          document_type: "licence",
          format: "licence",
          schema_name: "licence",
          title: "Licence to kill",
          public_updated_at: "2012-10-02T12:30:33.483Z",
          description: "Descriptive licence text.",
          details: {
            licence_identifier: "1071-5-1",
            licence_overview: "You only live twice, Mr Bond.\n",
          },
        })
        stub_licence_exists("1071-5-1", { "isLocationSpecific" => false })
      end

      should "set the cache expiry headers" do
        get :authority, params: { slug: "licence-to-kill", authority_slug: "secret-service" }

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    context "for live content when the licensing API times out" do
      setup do
        stub_content_store_has_item("/no-time-to-die", {
          base_path: "/no-time-to-die",
          document_type: "licence",
          format: "licence",
          schema_name: "licence",
          title: "No time to die",
          public_updated_at: "2021-10-02T12:30:33.483Z",
          description: "Descriptive licence text.",
          details: {
            licence_identifier: "0-0-7",
            licence_overview: "We have all the time in the world.\n",
          },
        })
        stub_licence_times_out "0-0-7"
      end

      should "set the no-cache cache control header" do
        get :authority, params: { slug: "no-time-to-die", authority_slug: "vesper" }

        assert_equal "no-cache", response.headers["Cache-Control"]
      end
    end
  end
end
