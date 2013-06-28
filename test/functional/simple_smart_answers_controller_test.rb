require 'test_helper'

class SimpleSmartAnswersControllerTest < ActionController::TestCase
  test "should get flow" do
    get :flow
    assert_response :success
  end

end
