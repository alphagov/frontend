require "test_helper"

class ElectoralControllerTest < ActionController::TestCase
  context "without postcode params" do
    should "GET show" do
      get :show
      assert_response :success
      assert_template :show
    end
  end

  should "with postcode params" do
    get :show, params: { postcode: "LS11UR" }
    assert_response :success
    assert_template :results
  end
end
