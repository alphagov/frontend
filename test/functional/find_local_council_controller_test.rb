require "test_helper"

class FindLocalCouncilControllerTest < ActionController::TestCase
  should "set correct expiry headers" do
    content_store_has_random_item(base_path: '/find-local-council')

    get :index

    assert_equal "max-age=1800, public", response.headers["Cache-Control"]
  end
end
