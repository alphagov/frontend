require "test_helper"

class HelpControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  context "GET index" do
    setup do
      content_store_has_random_item(base_path: "/help", schema: 'help_page')
    end

    should "set the cache expiry headers" do
      get :index

      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end

    should "redirect json requests to the api" do
      get :index, format: 'json'

      assert_redirected_to "/api/help.json"
    end
  end

  context "GET show" do
    setup do
      @artefact = artefact_for_slug('help/cookies')
      @artefact["format"] = "help"
    end

    context "for live content" do
      setup do
        content_store_has_random_item(base_path: '/help/cookies', schema: 'help_page')
      end

      should "set the cache expiry headers" do
        get :show, slug: "help/cookies"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :show, slug: "help/cookies", format: 'json'

        assert_redirected_to "/api/help/cookies.json"
      end
    end
  end

  context "loading the tour page" do
    setup do
      content_store_has_random_item(base_path: "/tour", schema: 'help_page')
    end

    should "respond with success" do
      get :tour

      assert_response :success
    end

    should "set correct expiry headers" do
      get :tour

      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end
  end

  context "GET ab-testing" do
    %w[A B].each do |variant|
      should "not affect non-AB-testing pages with the #{variant} variant" do
        content_store_has_random_item(base_path: "/tour", schema: 'help_page')
        setup_ab_variant('Example', variant)
        get :tour
        assert_response_not_modified_for_ab_test('EducationNavigation')
      end
    end

    should "respond with success" do
      get :ab_testing, slug: "help/ab-testing"

      assert_response :success
    end

    should "show the user the 'A' version if the user is in bucket 'A'" do
      with_variant Example: 'A' do
        get :ab_testing

        assert_select ".ab-example-group", text: "A"
      end
    end

    should "show the user the 'B' version if the user is in bucket 'B'" do
      with_variant Example: 'B' do
        get :ab_testing

        assert_select ".ab-example-group", text: "B"
      end
    end

    should "show the user the default version if the user is not in a bucket" do
      get :ab_testing

      assert_select ".ab-example-group", text: "A"
    end

    should "show the user the default version if the user is in an unknown bucket" do
      with_variant Example: 'not_a_valid_AB_test_value' do
        get :ab_testing

        assert_select ".ab-example-group", text: "A"
      end
    end
  end
end
