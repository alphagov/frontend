require "test_helper"

class AnswerControllerTest < ActionController::TestCase
  include EducationNavigationAbTestHelper

  context "GET show" do
    setup do
      @artefact = artefact_for_slug('vat-rates')
      @artefact["format"] = "answer"
    end

    context "for live content" do
      setup do
        content_api_and_content_store_have_page('vat-rates', @artefact)
      end

      should "set the cache expiry headers" do
        get :show, slug: "vat-rates"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :show, slug: "vat-rates", format: 'json'

        assert_redirected_to "/api/vat-rates.json"
      end
    end

    context "for draft content" do
      setup do
        content_api_and_content_store_have_unpublished_page("vat-rates", 3, @artefact)
      end

      should "does not set the cache expiry headers" do
        get :show, slug: "vat-rates", edition: 3

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
        get :show, slug: "a-slug"
        assert_match(/NormalBreadcrumb/, response.body)
        refute_match(/TaxonBreadcrumb/, response.body)
      end

      should "show normal breadcrumbs for the 'A' version" do
        with_variant educationnavigation: "A" do
          get :show, slug: "a-slug"
          assert_match(/NormalBreadcrumb/, response.body)
          refute_match(/TaxonBreadcrumb/, response.body)
        end
      end

      should "show taxon breadcrumbs for the 'B' version" do
        with_variant educationnavigation: "B" do
          get :show, slug: "a-slug"
          assert_match(/TaxonBreadcrumb/, response.body)
          refute_match(/NormalBreadcrumb/, response.body)
        end
      end
    end
  end
end
