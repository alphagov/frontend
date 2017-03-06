require 'integration_test_helper'

class HomepageTest < ActionDispatch::IntegrationTest
  include EducationNavigationAbTestHelper

  should "render the homepage" do
    visit "/"
    assert_equal 200, page.status_code
    assert_equal "Welcome to GOV.UK", page.title
  end

  should "not render breadcrumbs" do
    visit "/"
    assert_nil page.body.match(/govuk-breadcrumbs/)
  end

  context "A/B test" do
    ORIGINAL_EDUCATION_TITLE = "Education and learning".freeze
    NEW_EDUCATION_TITLE = "Education, training and skills".freeze

    context "when feature flag is off" do
      %w[A B].each do |variant|
        should "render the original version for the #{variant} variant" do
          setup_ab_variant('EducationNavigation', variant)

          visit "/"

          assert page.has_text?(ORIGINAL_EDUCATION_TITLE)
          assert page.has_no_text?(NEW_EDUCATION_TITLE)
          assert_response_not_modified_for_ab_test
        end
      end
    end

    context "when feature flag is on" do
      setup do
        set_new_navigation
      end

      teardown do
        teardown_education_navigation_ab_test
      end

      %w[A B].each do |variant|
        should "cache the #{variant} variant separately" do
          setup_ab_variant("EducationNavigation", variant)

          visit "/"

          assert_response_is_cached_by_variant("EducationNavigation")
        end

        # The homepage is not part of the education content. Adding the A/B
        # tracking dimension to the homepage would flood the A/B test analytics
        # with every user journey that included the GOV.UK homepage.
        should "not track analytics for the #{variant} variant" do
          setup_ab_variant("EducationNavigation", variant)

          visit "/"

          assert_page_not_tracked_in_ab_test
        end
      end

      should "render the original version for the A variant" do
        setup_ab_variant('EducationNavigation', "A")

        visit "/"

        assert page.has_text?(ORIGINAL_EDUCATION_TITLE)
        assert page.has_no_text?(NEW_EDUCATION_TITLE)
      end

      should "render the new version for the B variant" do
        setup_ab_variant('EducationNavigation', "B")

        visit "/"

        assert page.has_text?(NEW_EDUCATION_TITLE)
        assert page.has_no_text?(ORIGINAL_EDUCATION_TITLE)
      end
    end
  end
end
