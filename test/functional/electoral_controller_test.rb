require "test_helper"

class ElectoralControllerTest < ActionController::TestCase
  context "without postcode params" do
    should "GET show renders show page with form" do
      get :show
      assert_response :success
      assert_template :show
    end
  end

  context "with postcode params" do
    context "that map to a single address" do
      should "GET show renders results page" do
        stub_democracy_club_api =
          stub_request(:get, "https://api.ec-dc.club/api/v1/postcode/LS11UR")
          .to_return(status: 200, body: "{}")

        get :show, params: { postcode: "LS11UR" }
        assert_response :success
        assert_template :results
        assert_requested(stub_democracy_club_api)
      end
    end

    context "that maps to multiple addresses" do
      should "GET show renders the address picker template" do
        response = "{\"address_picker\":true,\"addresses\":[]}"
        stub_request(:get, "https://api.ec-dc.club/api/v1/postcode/IP224DN")
        .to_return(status: 200, body: response)

        get :show, params: { postcode: "IP224DN" }
        assert_response :success
        assert_template :address_picker
      end
    end
  end

  context "with uprn params" do
    should "GET show renders results page" do
      stub_address_endpoint =
        stub_request(:get, "https://api.ec-dc.club/api/v1/address/1234")
        .to_return(status: 200, body: "{}")

      get :show, params: { uprn: "1234" }
      assert_response :success
      assert_template :results
      assert_requested(stub_address_endpoint)
    end
  end
end
