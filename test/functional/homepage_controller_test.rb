require "test_helper"

class HomepageControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  context "loading the homepage" do
    setup do
      stub_content_store_has_item("/", schema: "special_route")
    end

    should "respond with success" do
      get :index
      assert_response :success
    end

    should "set correct expiry headers" do
      get :index
      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end
  end
end
