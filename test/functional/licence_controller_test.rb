require "test_helper"
require 'gds_api/test_helpers/mapit'

class LicenceControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::Mapit
  include EducationNavigationAbTestHelper

  context "GET search" do
    setup do
      @artefact = artefact_for_slug('licence-to-kill')
      @artefact["format"] = "licence"
    end

    context "for live content" do
      setup do
        content_api_and_content_store_have_page('licence-to-kill', @artefact)
      end

      should "set the cache expiry headers" do
        get :search, slug: "licence-to-kill"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :search, slug: "licence-to-kill", format: 'json'

        assert_redirected_to "/api/licence-to-kill.json"
      end
    end

    context "for draft content" do
      setup do
        content_api_and_content_store_have_unpublished_page("licence-to-kill", 3, @artefact)
      end

      should "does not set the cache expiry headers" do
        get :search, slug: "licence-to-kill", edition: 3

        assert_nil response.headers["Cache-Control"]
      end
    end

    context "A/B testing" do
      setup do
        setup_education_navigation_ab_test
      end

      teardown do
        teardown_education_navigation_ab_test
      end

      should "show normal breadcrumbs by default" do
        get :search, slug: "a-slug"
        assert_match(/NormalBreadcrumb/, response.body)
        refute_match(/TaxonBreadcrumb/, response.body)
      end

      should "show normal breadcrumbs for the 'A' version" do
        with_variant educationnavigation: "A" do
          get :search, slug: "a-slug"
          assert_match(/NormalBreadcrumb/, response.body)
          refute_match(/TaxonBreadcrumb/, response.body)
        end
      end

      should "show taxon breadcrumbs for the 'B' version" do
        with_variant educationnavigation: "B" do
          get :search, slug: "a-slug"
          assert_match(/TaxonBreadcrumb/, response.body)
          refute_match(/NormalBreadcrumb/, response.body)
        end
      end
    end
  end

  context "POST to search" do
    setup do
      content_api_and_content_store_have_page('licence-to-kill',
        "format" => "licence",
        "web_url" => "http://example.org/licence-to-kill",
        "title" => "Licence to kill",
        "details" => {}
      )
    end

    context "loading the licence edition when posting a location" do
      context "for an English local authority" do
        setup do
          mapit_has_a_postcode_and_areas("ST10 4DB", [0, 0], [
            { "name" => "Staffordshire County Council", "type" => "CTY", "ons" => "41", "govuk_slug" => "staffordshire-county" },
            { "name" => "Staffordshire Moorlands District Council", "type" => "DIS", "ons" => "41UH", "govuk_slug" => "staffordshire-moorlands" },
            { "name" => "Cheadle and Checkley", "type" => "CED" }
          ])

          post :search, slug: "licence-to-kill", postcode: "ST10 4DB"
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

          post :search, slug: "licence-to-kill", postcode: "BT1 5GS"
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
        content_api_and_content_store_have_page('licence-to-kill', @artefact)
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
        content_api_and_content_store_have_unpublished_page("licence-to-kill", 3, @artefact)
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

      teardown do
        teardown_education_navigation_ab_test
      end

      should "show normal breadcrumbs by default" do
        get :authority, slug: "a-slug", authority_slug: "auth-slug"
        assert_match(/NormalBreadcrumb/, response.body)
        refute_match(/TaxonBreadcrumb/, response.body)
      end

      should "show normal breadcrumbs for the 'A' version" do
        with_variant educationnavigation: "A" do
          get :authority, slug: "a-slug", authority_slug: "auth-slug"
          assert_match(/NormalBreadcrumb/, response.body)
          refute_match(/TaxonBreadcrumb/, response.body)
        end
      end

      should "show taxon breadcrumbs for the 'B' version" do
        with_variant educationnavigation: "B" do
          get :authority, slug: "a-slug", authority_slug: "auth-slug"
          assert_match(/TaxonBreadcrumb/, response.body)
          refute_match(/NormalBreadcrumb/, response.body)
        end
      end
    end
  end
end
