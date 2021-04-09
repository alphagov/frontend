require "test_helper"

class ElectoralControllerTest < ActionController::TestCase
  test "GET show" do
    get :show
    assert_response :success
  end
end
