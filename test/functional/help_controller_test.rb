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
end
