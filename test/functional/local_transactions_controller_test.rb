require 'test_helper'

require 'gds_api/part_methods'
require 'gds_api/test_helpers/mapit'
require 'gds_api/test_helpers/local_links_manager'

class LocalTransactionsControllerTest < ActionController::TestCase
  tests RootController
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::LocalLinksManager

  def subscribe_logstasher_to_postcode_error_notification
    LogStasher.watch('postcode_error_notification') do |_name, _start, _finish, _id, payload, store|
      store[:postcode_error] = payload[:postcode_error]
    end
  end

  context "given a local transaction exists in content api" do
    setup do
      @artefact = {
        "title" => "Send a bear to your local council",
        "format" => "local_transaction",
        "web_url" => "http://example.org/send-a-bear-to-your-local-council",
        "details" => {
          "format" => "LocalTransaction",
          "lgsl_code" => "8342",
          "local_service" => {
            "description" => "What could go wrong?",
            "lgsl_code" => "8342",
            "providing_tier" => %w(district unitary)
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

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    context "loading the local transaction when posting a location" do
      context "for an English local authority" do
        setup do
          mapit_has_a_postcode_and_areas("ST10 4DB", [0, 0], [
            { "name" => "Staffordshire County Council", "type" => "CTY", "ons" => "41", "govuk_slug" => "staffordshire-county"},
            { "name" => "Staffordshire Moorlands District Council", "type" => "DIS", "ons" => "41UH", "govuk_slug" => "staffordshire-moorlands"},
            { "name" => "Cheadle and Checkley", "type" => "CED" }
          ])

          post :publication, slug: "send-a-bear-to-your-local-council", postcode: "ST10-4DB] "
        end

        should "sanitize postcodes and redirect to the slug for the appropriate authority tier" do
          assert_redirected_to "/send-a-bear-to-your-local-council/staffordshire-moorlands"
        end
      end
    end

    context "loading the local transaction when posting an invalid postcode" do
      setup do
        mapit_does_not_have_a_bad_postcode("BLAH")

        subscribe_logstasher_to_postcode_error_notification

        post :publication, slug: "send-a-bear-to-your-local-council", postcode: "BLAH"
      end

      should "expose the 'invalid postcode format' error to the view" do
        location_error = assigns(:location_error)
        assert_equal location_error.postcode_error, "invalidPostcodeFormat"
      end

      should "log the 'invalid postcode format' error to the view" do
        assert_equal(LogStasher.store["postcode_error_notification"], { postcode_error: "invalidPostcodeFormat" })
      end
    end

    context "loading the local transaction when posting a postcode with no matching areas" do
      setup do
        mapit_does_not_have_a_postcode("WC1E 9ZZ")

        subscribe_logstasher_to_postcode_error_notification

        post :publication, slug: "send-a-bear-to-your-local-council", postcode: "WC1E 9ZZ"
      end

      should "expose the 'no mapit match' error to the view" do
        location_error = assigns(:location_error)
        assert_equal location_error.postcode_error, "fullPostcodeNoMapitMatch"
      end

      should "log the 'no mapit match' error to the view" do
        assert_equal(LogStasher.store["postcode_error_notification"], { postcode_error: "fullPostcodeNoMapitMatch" })
      end
    end

    context "loading the local transaction when posting a location that has no matching local authority" do
      setup do
        mapit_has_a_postcode_and_areas("AB1 2CD", [0, 0], [])

        subscribe_logstasher_to_postcode_error_notification

        post :publication, slug: "send-a-bear-to-your-local-council", postcode: "AB1 2CD"
      end

      should "expose the 'missing local authority' error to the view" do
        location_error = assigns(:location_error)
        assert_equal "noLaMatch", location_error.postcode_error
      end

      should "log the 'missing local authority' error to the view" do
        assert_equal(LogStasher.store["postcode_error_notification"], { postcode_error: "noLaMatch" })
      end
    end

    context "loading the local transaction for an authority" do
      setup do
        staffordshire_moorlands = {
          "id" => 2432,
          "codes" => {
            "ons" => "41UH",
            "gss" => "E07000198",
            "govuk_slug" => "staffordshire-moorlands"
          },
          "name" => "Staffordshire Moorlands District Council",
        }

        mapit_has_area_for_code('govuk_slug', 'staffordshire-moorlands', staffordshire_moorlands)
        local_links_manager_has_a_fallback_link(
          authority_slug: 'staffordshire-moorlands',
          lgsl: 8342,
          lgil: 8,
          url: 'http://www.staffsmoorlands.gov.uk/sm/council-services/parks-and-open-spaces/parks'
        )
      end

      should "assign local transaction information" do
        get :publication, slug: "send-a-bear-to-your-local-council", part: "staffordshire-moorlands"

        assert_equal "http://www.staffsmoorlands.gov.uk/sm/council-services/parks-and-open-spaces/parks", assigns(:interaction_details)["local_interaction"]["url"]
      end
    end

    should "return a 404 for an incorrect authority slug" do
      mapit_does_not_have_area_for_code('govuk_slug', 'this-slug-should-not-exist')

      get :publication, slug: "send-a-bear-to-your-local-council", part: "this-slug-should-not-exist"

      assert_equal 404, response.status
    end
  end

  context "loading a local transaction without an interaction that exists in content api" do
    setup do
      @artefact = {
        "title" => "Report a bear on a local road",
        "format" => "local_transaction",
        "web_url" => "http://example.org/report-a-bear-on-a-local-road",
        "details" => {
          "format" => "LocalTransaction",
          "lgsl_code" => "1234",
          "local_service" => {
            "description" => "Contact your council to dispatch Cousin Sven's bear enforcement squad in your area.",
            "lgsl_code" => "1234",
            "providing_tier" => %w(district unitary)
          },
        }
      }

      staffordshire_moorlands = {
        "id" => 2432,
        "codes" => {
          "ons" => "41UH",
          "gss" => "E07000198",
          "govuk_slug" => "staffordshire-moorlands"
        },
        "name" => "Staffordshire Moorlands District Council",
      }

      mapit_has_area_for_code('govuk_slug', 'staffordshire-moorlands', staffordshire_moorlands)
      content_api_has_an_artefact('report-a-bear-on-a-local-road', @artefact)
      local_links_manager_has_no_fallback_link(
        authority_slug: 'staffordshire-moorlands',
        lgsl: 1234,
      )

      subscribe_logstasher_to_postcode_error_notification
      get :publication, slug: "report-a-bear-on-a-local-road", part: "staffordshire-moorlands"
    end

    should "show error message" do
      assert response.ok?
      assert response.body.include?("Search")
    end

    should "expose the 'missing interaction' error to the view" do
      location_error = assigns(:location_error)
      assert_equal "laMatchNoLink", location_error.postcode_error
    end

    should "log the 'missing interaction' error to the view" do
      assert_equal(LogStasher.store["postcode_error_notification"], { postcode_error: "laMatchNoLink" })
    end
  end
end
