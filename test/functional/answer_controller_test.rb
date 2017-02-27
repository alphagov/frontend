require "test_helper"

class AnswerControllerTest < ActionController::TestCase
  include EducationNavigationAbTestHelper

  context "GET show" do
    setup do
      content_store_has_random_item(base_path: "/molehills", schema: 'answer')
    end

    context "for live content" do
      should "set the cache expiry headers" do
        get :show, slug: "molehills"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :show, slug: "molehills", format: 'json'

        assert_redirected_to "/api/molehills.json"
      end
    end

    context "for draft content" do
      setup do
        content_store_has_random_item(base_path: '/molehills', schema: 'answer')
      end

      should "does not set the cache expiry headers" do
        get :show, slug: "molehills", edition: 3

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

      should "show normal navigation by default" do
        get :show, slug: "a-slug"

        assert_normal_navigation_visible
      end

      should "show normal breadcrumbs for the 'A' version" do
        with_variant EducationNavigation: "A" do
          get :show, slug: "a-slug"

          assert_normal_navigation_visible
        end
      end

      should "show taxon breadcrumbs for the 'B' version" do
        with_variant EducationNavigation: "B" do
          get :show, slug: "a-slug"

          assert_taxonomy_navigation_visible
        end
      end
    end
  end
end
