require_relative "../test_helper"

class CampaignControllerTest < ActionController::TestCase

  should "set slimmer format of campaign" do
    get :workplace_pensions
    assert_equal "campaign",  response.headers["X-Slimmer-Format"]
  end

  should "set correct expiry headers" do
    get :workplace_pensions

    assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
  end

  should "load the workplace pensions campaign" do
    get :workplace_pensions

    assert_response :success
  end

  should "load the UK Welcomes campaign" do
    get :uk_welcomes

    assert_response :success
  end
end
