require "test_helper"

class RoadmapControllerTest < ActionController::TestCase
  context "GET index" do
    setup do
      content_store_has_random_item(base_path: "/roadmap", schema: "special_route")
    end

    should "set the cache expiry headers" do
      get :index

      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end
  end
end
