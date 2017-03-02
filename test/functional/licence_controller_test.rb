require "test_helper"
require 'gds_api/test_helpers/mapit'
require 'gds_api/test_helpers/licence_application'

class LicenceControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::LicenceApplication
  include EducationNavigationAbTestHelper

  context "GET start" do
    setup do
      @artefact = artefact_for_slug('licence-to-kill')
      @artefact["format"] = "licence"
    end

    context "for live content" do
      setup do
        content_api_and_content_store_have_page('licence-to-kill', artefact: @artefact)
      end

      should "set the cache expiry headers" do
        get :start, slug: "licence-to-kill"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :start, slug: "licence-to-kill", format: 'json'

        assert_redirected_to "/api/licence-to-kill.json"
      end
    end

    context "for draft content" do
      setup do
        content_api_and_content_store_have_unpublished_page("licence-to-kill", 3, artefact: @artefact)
      end

      should "does not set the cache expiry headers" do
        get :start, slug: "licence-to-kill", edition: 3

        assert_nil response.headers["Cache-Control"]
      end
    end

    context "A/B testing" do
      setup do
        setup_education_navigation_ab_test
      end

      %w[A B].each do |variant|
        should "not affect non-education pages with the #{variant} variant" do
          content_api_and_content_store_have_page('licence-to-kill', artefact: @artefact)
          setup_ab_variant('EducationNavigation', variant)
          expect_normal_navigation
          get :start, slug: "licence-to-kill"
          assert_response_not_modified_for_ab_test
        end
      end

      should "show normal breadcrumbs by default" do
        expect_normal_navigation
        get :start, slug: "tagged-to-taxon"
      end

      should "show normal breadcrumbs for the 'A' version" do
        expect_normal_navigation
        with_variant EducationNavigation: "A" do
          get :start, slug: "tagged-to-taxon"
        end
      end

      should "show taxon breadcrumbs for the 'B' version" do
        expect_new_navigation
        with_variant EducationNavigation: "B" do
          get :start, slug: "tagged-to-taxon"
        end
      end

      should "show taxon breadcrumbs and old related links for flagged mainstream content" do
        MainstreamContentFetcher.stubs(:with_curated_sidebar).returns(["/tagged-to-taxon"])

        expect_normal_navigation_and_old_related_links
        with_variant EducationNavigation: "B" do
          get :start, slug: "tagged-to-taxon"
        end
      end
    end
  end

  context "POST to start" do
    setup do
      content_api_and_content_store_have_page('licence-to-kill',
        artefact: {
          "format" => "licence",
          "web_url" => "http://example.org/licence-to-kill",
          "title" => "Licence to kill",
          "details" => {
            "licence_identifier" => "1071-5-1",
          }
        }
      )
    end

    context "loading the licence edition when posting a location" do
      setup do
        licence_exists('1071-5-1',
                       "isLocationSpecific" => true,
                       "isOfferedByCounty" => false,
                       "geographicalAvailability" => %w(England Wales),
                       "issuingAuthorities" => [])
      end

      context "for an English local authority" do
        setup do
          mapit_has_a_postcode_and_areas("ST10 4DB", [0, 0], [
            { "name" => "Staffordshire County Council", "type" => "CTY", "ons" => "41", "govuk_slug" => "staffordshire-county" },
            { "name" => "Staffordshire Moorlands District Council", "type" => "DIS", "ons" => "41UH", "govuk_slug" => "staffordshire-moorlands" },
            { "name" => "Cheadle and Checkley", "type" => "CED" }
          ])

          post :start, slug: "licence-to-kill", postcode: "ST10 4DB"
        end

        should "redirect to the slug for the lowest level authority" do
          assert_redirected_to "/licence-to-kill/staffordshire-moorlands"
        end
      end

      context "for a Northern Irish local authority" do
        setup do
          mapit_has_a_postcode_and_areas("BT1 5GS", [0, 0], [
            { "name" => "Belfast City Council", "type" => "LGD", "ons" => "N09000003", "govuk_slug" => "belfast" },
            { "name" => "Shaftesbury", "type" => "LGW", "ons" => "95Z24" },
          ])

          post :start, slug: "licence-to-kill", postcode: "BT1 5GS"
        end

        should "redirect to the slug for the lowest level authority" do
          assert_redirected_to "/licence-to-kill/belfast"
        end
      end
    end
  end

  context "GET authority" do
    setup do
      @artefact = artefact_for_slug('licence-to-kill')
      @artefact["format"] = "licence"
    end

    context "for live content" do
      setup do
        content_api_and_content_store_have_page('licence-to-kill', artefact: @artefact)
      end

      should "set the cache expiry headers" do
        get :authority, slug: "licence-to-kill", authority_slug: "secret-service"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :authority, slug: "licence-to-kill", authority_slug: "secret-service", format: 'json'

        assert_redirected_to "/api/licence-to-kill.json"
      end
    end

    context "for draft content" do
      setup do
        content_api_and_content_store_have_unpublished_page("licence-to-kill", 3, artefact: @artefact)
      end

      should "does not set the cache expiry headers" do
        get :authority, slug: "licence-to-kill", authority_slug: "secret-service", edition: 3

        assert_nil response.headers["Cache-Control"]
      end
    end

    context "A/B testing" do
      setup do
        setup_education_navigation_ab_test
      end

      %w[A B].each do |variant|
        should "not affect non-education pages with the #{variant} variant" do
          content_api_and_content_store_have_page('licence-to-kill', artefact: @artefact)
          setup_ab_variant('EducationNavigation', variant)
          expect_normal_navigation
          get :authority, slug: "licence-to-kill", authority_slug: "secret-service"
          assert_response_not_modified_for_ab_test
        end
      end

      should "show normal breadcrumbs by default" do
        expect_normal_navigation
        get :authority, slug: "tagged-to-taxon", authority_slug: "auth-slug"
      end

      should "show normal breadcrumbs for the 'A' version" do
        expect_normal_navigation
        with_variant EducationNavigation: "A" do
          get :authority, slug: "tagged-to-taxon", authority_slug: "auth-slug"
        end
      end

      should "show taxon breadcrumbs for the 'B' version" do
        expect_new_navigation
        with_variant EducationNavigation: "B" do
          get :authority, slug: "tagged-to-taxon", authority_slug: "auth-slug"
        end
      end
    end
  end
end
