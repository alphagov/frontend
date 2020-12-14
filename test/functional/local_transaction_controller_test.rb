require "test_helper"

require "gds_api/test_helpers/mapit"
require "gds_api/test_helpers/local_links_manager"

class LocalTransactionControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::LocalLinksManager
  include LocationHelpers

  def subscribe_logstasher_to_postcode_error_notification
    LogStasher.watch("postcode_error_notification") do |_name, _start, _finish, _id, payload, store|
      store[:postcode_error] = payload[:postcode_error]
    end
  end

  test "Should not allow framing of local transaction pages" do
    content_store_has_random_item(base_path: "/a-slug", schema: "local_transaction")

    prevent_implicit_rendering
    get :search, params: { slug: "a-slug" }
    assert_equal "DENY", @response.headers["X-Frame-Options"]
  end

  test "should set expiry headers for an edition" do
    content_store_has_random_item(base_path: "/a-slug", schema: "local_transaction")

    get :search, params: { slug: "a-slug" }
    assert_equal "max-age=1800, public", response.headers["Cache-Control"]
  end

  context "given a local transaction exists in content store" do
    setup do
      @payload_bear = {
        analytics_identifier: nil,
        base_path: "/pay-bear-tax",
        content_id: "d6d6caaf-77db-47e1-8206-30cd4f3d0e3f",
        document_type: "local_transaction",
        first_published_at: "2016-02-29T09:24:10.000+00:00",
        format: "local_transaction",
        locale: "en",
        phase: "beta",
        public_updated_at: "2014-12-16T12:49:50.000+00:00",
        publishing_app: "publisher",
        rendering_app: "frontend",
        schema_name: "local_transaction",
        title: "Send a bear to your local council",
        updated_at: "2017-01-30T12:30:33.483Z",
        withdrawn_notice: {},
        links: {},
        description: "Descriptive bear text.",
        details: {
          lgsl_code: 8342,
          lgil_code: 8,
          service_tiers: %w[district unitary],
          introduction: "Infos about sending bears.",
        },
        external_related_links: [],
      }

      @payload_electoral = {
        analytics_identifier: nil,
        base_path: "/get-on-electoral-register",
        content_id: "d6d6caaf-77db-47e1-8206-30cd4f3hwe78",
        document_type: "local_transaction",
        first_published_at: "2016-02-29T09:24:10.000+00:00",
        format: "local_transaction",
        locale: "en",
        phase: "beta",
        public_updated_at: "2014-12-16T12:49:50.000+00:00",
        publishing_app: "publisher",
        rendering_app: "frontend",
        schema_name: "local_transaction",
        title: "Get on electoral register",
        updated_at: "2017-01-30T12:30:33.483Z",
        withdrawn_notice: {},
        links: {},
        description: "Descriptive text.",
        details: {
          lgsl_code: 364,
          lgil_code: 8,
          service_tiers: %w[district unitary],
          introduction: "Infos about registering to vote.",
        },
        external_related_links: [],
      }

      stub_content_store_has_item("/send-a-bear-to-your-local-council", @payload_bear)
      stub_content_store_has_item("/get-on-electoral-register", @payload_electoral)
    end

    context "loading the local transaction edition without any location" do
      should "return the normal content for a page" do
        get :search, params: { slug: "send-a-bear-to-your-local-council" }

        assert_response :success
        assert_equal assigns(:publication).title, "Send a bear to your local council"
      end

      should "set correct expiry headers" do
        get :search, params: { slug: "send-a-bear-to-your-local-council" }

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    context "loading the local transaction when posting a location" do
      context "for an English local authority" do
        setup do
          stub_mapit_has_a_postcode_and_areas(
            "ST10 4DB",
            [0, 0],
            [
              { "name" => "Staffordshire County Council", "type" => "CTY", "ons" => "41", "govuk_slug" => "staffordshire-county", "country_name" => "England" },
              { "name" => "Staffordshire Moorlands District Council", "type" => "DIS", "ons" => "41UH", "govuk_slug" => "staffordshire-moorlands", "country_name" => "England" },
              { "name" => "Cheadle and Checkley", "type" => "CED", "country_name" => "England" },
            ],
          )

          post :search, params: { slug: "send-a-bear-to-your-local-council", postcode: "ST10-4DB] " }
        end

        should "sanitize postcodes and redirect to the slug for the appropriate authority tier" do
          assert_redirected_to "/send-a-bear-to-your-local-council/staffordshire-moorlands"
        end
      end

      context "for a Northern Ireland local authority" do
        setup do
          stub_mapit_has_a_postcode_and_areas(
            "BT1 4QG",
            [0, 0],
            [
              { "name" => "Belfast City Council", "type" => "LGD", "govuk_slug" => "belfast", "country_name" => "Northern Ireland" },
            ],
          )

          post :search, params: { slug: "send-a-bear-to-your-local-council", postcode: "BT1-4QG] " }
        end

        should "sanitize postcodes and redirect to the slug for the appropriate authority tier" do
          assert_redirected_to "/send-a-bear-to-your-local-council/belfast"
        end
      end

      context "for electoral registration for an English local authority" do
        setup do
          stub_mapit_has_a_postcode_and_areas(
            "ST10 4DB",
            [0, 0],
            [
              { "name" => "Staffordshire County Council", "type" => "CTY", "ons" => "41", "govuk_slug" => "staffordshire-county", "country_name" => "England" },
              { "name" => "Staffordshire Moorlands District Council", "type" => "DIS", "ons" => "41UH", "govuk_slug" => "staffordshire-moorlands", "country_name" => "England" },
              { "name" => "Cheadle and Checkley", "type" => "CED", "country_name" => "England" },
            ],
          )

          post :search, params: { slug: "get-on-electoral-register", postcode: "ST10-4DB] " }
        end

        should "sanitize postcodes and redirect to the slug for the appropriate authority tier" do
          assert_redirected_to "/get-on-electoral-register/staffordshire-moorlands"
        end
      end

      context "for electoral registration for a Northern Ireland local authority" do
        setup do
          stub_mapit_has_a_postcode_and_areas(
            "BT1 3QG",
            [0, 0],
            [
              { "name" => "Belfast City Council", "type" => "LGD", "govuk_slug" => "belfast", "country_name" => "Northern Ireland" },
            ],
          )

          post :search, params: { slug: "get-on-electoral-register", postcode: "BT1-3QG] " }
        end

        should "sanitize postcodes and redirect to the slug for the appropriate authority tier" do
          assert_redirected_to "/get-on-electoral-register/electoral-office-for-northern-ireland"
        end
      end
    end

    context "loading the local transaction when posting an invalid postcode" do
      setup do
        stub_mapit_does_not_have_a_bad_postcode("BLAH")

        subscribe_logstasher_to_postcode_error_notification

        post :search, params: { slug: "send-a-bear-to-your-local-council", postcode: "BLAH" }
      end

      should "expose the 'invalid postcode format' error to the view" do
        location_error = assigns(:location_error)
        assert_equal location_error.postcode_error, "invalidPostcodeFormat"
      end

      should "log the 'invalid postcode format' error to the view" do
        assert_equal(LogStasher.store["postcode_error_notification"], postcode_error: "invalidPostcodeFormat")
      end
    end

    context "loading the local transaction when posting a postcode with no matching areas" do
      setup do
        stub_mapit_does_not_have_a_postcode("WC1E 9ZZ")

        subscribe_logstasher_to_postcode_error_notification

        post :search, params: { slug: "send-a-bear-to-your-local-council", postcode: "WC1E 9ZZ" }
      end

      should "expose the 'no mapit match' error to the view" do
        location_error = assigns(:location_error)
        assert_equal location_error.postcode_error, "fullPostcodeNoMapitMatch"
      end

      should "log the 'no mapit match' error to the view" do
        assert_equal(LogStasher.store["postcode_error_notification"], postcode_error: "fullPostcodeNoMapitMatch")
      end
    end

    context "loading the local transaction when posting a location that has no matching local authority" do
      setup do
        stub_mapit_has_a_postcode_and_areas("AB1 2CD", [0, 0], [])

        subscribe_logstasher_to_postcode_error_notification

        post :search, params: { slug: "send-a-bear-to-your-local-council", postcode: "AB1 2CD" }
      end

      should "expose the 'missing local authority' error to the view" do
        location_error = assigns(:location_error)
        assert_equal "noLaMatch", location_error.postcode_error
      end

      should "log the 'missing local authority' error to the view" do
        assert_equal(LogStasher.store["postcode_error_notification"], postcode_error: "noLaMatch")
      end
    end

    context "loading the local transaction for an authority" do
      setup do
        staffordshire_moorlands = {
          "id" => 2432,
          "codes" => {
            "ons" => "41UH",
            "gss" => "E07000198",
            "govuk_slug" => "staffordshire-moorlands",
          },
          "name" => "Staffordshire Moorlands District Council",
        }

        stub_mapit_has_area_for_code("govuk_slug", "staffordshire-moorlands", staffordshire_moorlands)

        stub_local_links_manager_has_a_link(
          authority_slug: "staffordshire-moorlands",
          lgsl: 8342,
          lgil: 8,
          url: "http://www.staffsmoorlands.gov.uk/sm/council-services/parks-and-open-spaces/parks",
          country_name: "England",
        )
      end

      should "assign local transaction information" do
        get :results, params: { slug: "send-a-bear-to-your-local-council", local_authority_slug: "staffordshire-moorlands" }

        assert_equal "http://www.staffsmoorlands.gov.uk/sm/council-services/parks-and-open-spaces/parks", assigns(:interaction_details)["local_interaction"]["url"]
      end
    end

    should "return a 404 for an incorrect authority slug" do
      stub_local_links_manager_does_not_have_required_objects("this-slug-should-not-exist", "8342", "8")

      get :results, params: { slug: "send-a-bear-to-your-local-council", local_authority_slug: "this-slug-should-not-exist" }

      assert_equal 404, response.status
    end
  end

  context "loading a local transaction without an interaction that exists in content store" do
    setup do
      @payload = {
        analytics_identifier: nil,
        base_path: "/report-a-bear-on-a-local-road",
        content_id: "d6d6caaf-77db-47e1-8206-30cd4f3d0e3f",
        document_type: "local_transaction",
        first_published_at: "2016-02-29T09:24:10.000+00:00",
        format: "local_transaction",
        locale: "en",
        phase: "beta",
        public_updated_at: "2014-12-16T12:49:50.000+00:00",
        publishing_app: "publisher",
        rendering_app: "frontend",
        schema_name: "local_transaction",
        title: "Send a bear to your local council",
        updated_at: "2017-01-30T12:30:33.483Z",
        withdrawn_notice: {},
        links: {},
        description: "Descriptive bear text.",
        details: {
          lgsl_code: 1234,
          lgil_code: 1,
          service_tiers: %w[district unitary],
          introduction: "Infos about sending bears.",
        },
        external_related_links: [],
      }

      staffordshire_moorlands = {
        "id" => 2432,
        "codes" => {
          "ons" => "41UH",
          "gss" => "E07000198",
          "govuk_slug" => "staffordshire-moorlands",
        },
        "name" => "Staffordshire Moorlands District Council",
      }

      stub_mapit_has_area_for_code("govuk_slug", "staffordshire-moorlands", staffordshire_moorlands)
      stub_local_links_manager_has_no_link(
        authority_slug: "staffordshire-moorlands",
        lgsl: 1234,
        lgil: 1,
        country_name: "England",
      )

      subscribe_logstasher_to_postcode_error_notification
      stub_content_store_has_item("/report-a-bear-on-a-local-road", @payload)
      get :results, params: { slug: "report-a-bear-on-a-local-road", local_authority_slug: "staffordshire-moorlands" }
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
      assert_equal(LogStasher.store["postcode_error_notification"], postcode_error: "laMatchNoLink")
    end
  end

  context "when visiting a local transaction which is in fact check" do
    setup do
      configure_mapit_and_local_links(postcode: "SW1A 1AA", authority: "westminster", lgsl: 461, lgil: 8)

      @payload = {
        base_path: "/pay-bear-tax",
        document_type: "local_transaction",
        format: "local_transaction",
        schema_name: "local_transaction",
        details: {
          lgsl_code: 461,
          lgil_code: 8,
          service_tiers: %w[county unitary],
          introduction: "Information about paying local tax on owning or looking after a bear.",
        },
      }

      stub_content_store_has_item("/pay-bear-tax", @payload)
    end

    should "redirect to the correct authority and pass cache and token as params" do
      post :search, params: { slug: "pay-bear-tax", postcode: "SW1A 1AA", token: "123", cache: "abc" }

      assert_redirected_to "/pay-bear-tax/westminster?cache=abc&token=123"
    end
  end
end
