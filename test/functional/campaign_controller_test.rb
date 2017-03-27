require "test_helper"

class CampaignControllerTest < ActionController::TestCase
  context "UK Welcomes campaign" do
    should "set correct expiry headers" do
      get :uk_welcomes
      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end

    should "load the UK Welcomes campaign" do
      get :uk_welcomes
      assert_response :success
    end
  end
end
