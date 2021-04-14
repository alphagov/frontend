require "test_helper"

class ElectoralControllerTest < ActionController::TestCase
  setup do
    stub_content_store_has_item("/contact-electoral-registration-office")
  end

  context "without postcode params" do
    should "GET show renders show page with form" do
      get :show
      assert_response :success
      assert_template "local_transaction/search"
      assert_template partial: "electoral/_form"
      assert_template partial: "application/_location_form", count: 0
    end
  end

  context "with postcode params" do
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
end
