require_relative "../test_helper"

class CampaignControllerTest < ActionController::TestCase

  should "set slimmer format of campaign" do
    get :workplace_pensions
    assert_equal "campaign",  response.headers["X-Slimmer-Format"]
  end
end