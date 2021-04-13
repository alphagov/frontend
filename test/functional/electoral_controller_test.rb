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
    stub_democracy_club_api =
      stub_request(:get, "https://api.ec-dc.club/api/v1/postcode/LS11UR")
      .to_return(status: 200, body: "{}")

    get :show, params: { postcode: "LS11UR" }
    assert_response :success
    assert_template :results
    assert_requested(stub_democracy_club_api)
  end
end
