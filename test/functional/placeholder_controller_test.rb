require "test_helper"

class PlaceholderControllerTest < ActionController::TestCase
  context "loading the placeholder page" do
    should "respond with success" do
      get :show
      assert_response :success
    end
  end
end
