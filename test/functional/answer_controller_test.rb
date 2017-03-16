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

      %w[A B].each do |variant|
        should "not affect non-education pages with the #{variant} variant" do
          setup_ab_variant('EducationNavigation', variant)
          expect_normal_navigation
          get :show, slug: "molehills"
          assert_response_not_modified_for_ab_test('EducationNavigation')
        end
      end

      should "show normal navigation by default" do
        expect_normal_navigation
        get :show, slug: "tagged-to-taxon"
      end

      should "show normal breadcrumbs for the 'A' version" do
        expect_normal_navigation
        with_variant EducationNavigation: "A" do
          get :show, slug: "tagged-to-taxon"
        end
      end

      should "show taxon breadcrumbs for the 'B' version" do
        expect_new_navigation
        with_variant EducationNavigation: "B" do
          get :show, slug: "tagged-to-taxon"
        end
      end
    end

    context "Benchmarking test" do
      should "show the mouseflow tag when in the benchmarking test" do
        with_variant Benchmarking: "B" do
          get :show, slug: "molehills"

          assert_select("script[src*=mouseflow]", 1, "Expected to find one script tag with the mouseflow js code on the page")
        end
      end

      should "not show the mouseflow tag when not in the benchmarking test" do
        with_variant Benchmarking: "A" do
          get :show, slug: "molehills"

          assert_select("script[src*=mouseflow]", 0, "Did not expect to find a script tag with the mouseflow js code on the page")
        end
      end
    end
  end
end
