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

    should "track the page as a 'finding' page type" do
      get :index
      assert_select "meta[name='govuk:user-journey-stage'][content='finding']", 1
    end
  end
end
