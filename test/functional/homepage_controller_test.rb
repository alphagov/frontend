require "test_helper"

class HomepageControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  context "loading the homepage" do
    setup do
      stub_content_store_has_item("/", schema: "special_route")
    end

    should "respond with success" do
      get :index
      assert_response :success
    end

    should "set correct expiry headers" do
      get :index
      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end

    context "AB testing of Explore navigational super menu" do
      should "request for Explore navigational super menu from slimmer" do
        with_variant ExploreMenuAbTestable: "A" do
          get :index

          assert response.successful?
          assert_equal "gem_layout_full_width", response.headers["X-Slimmer-Template"]
          assert_page_tracked_in_ab_test("ExploreMenuAbTestable", "A", 47)
        end

        with_variant ExploreMenuAbTestable: "B" do
          get :index

          assert response.successful?
          assert_equal "gem_layout_full_width_explore_header", response.headers["X-Slimmer-Template"]
          assert_page_tracked_in_ab_test("ExploreMenuAbTestable", "B", 47)
        end

        with_variant ExploreMenuAbTestable: "Z" do
          get :index

          assert response.successful?
          assert_equal "gem_layout_full_width", response.headers["X-Slimmer-Template"]
          assert_page_tracked_in_ab_test("ExploreMenuAbTestable", "Z", 47)
        end
      end
    end
  end
end
