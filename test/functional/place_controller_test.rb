require "test_helper"

class PlaceControllerTest < ActionController::TestCase
  context "GET show" do
    context "for live content" do
      setup do
        content_store_has_random_item(base_path: '/passport-interview-office', schema: 'place')
      end

      should "set the cache expiry headers" do
        get :show, params: { slug: "passport-interview-office" }

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end
  end
end
