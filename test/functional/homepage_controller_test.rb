require 'test_helper'

class HomepageControllerTest < ActionController::TestCase
  context "loading the homepage" do
    should "respond with success" do
      get :index
      assert_response :success
    end

    should "set correct expiry headers" do
      get :index
      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end

    should "set a Content-Security-Policy reporting header" do
      get :index
      assert response.headers["Content-Security-Policy-Report-Only"].start_with? 'default-src'
    end
  end
end
