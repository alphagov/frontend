require "test_helper"

class FindLocalCouncilControllerTest < ActionController::TestCase
  should "set correct expiry headers" do
    get :index
    assert_equal "max-age=1800, public", response.headers["Cache-Control"]
  end
end
