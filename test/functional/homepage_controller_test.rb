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
  end
end
