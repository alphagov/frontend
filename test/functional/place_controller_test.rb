require "test_helper"
require "gds_api/test_helpers/imminence"

class PlaceControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::Imminence

  valid_postcode = "SW1A 2AA"
  invalid_postcode = "1234 2AA"

  setup do
    content_store_has_random_item(base_path: "/passport-interview-office", schema: "place")
    stub_imminence_has_places_for_postcode([], "slug", valid_postcode, 10)
    stub_imminence_has_places_for_postcode([], "slug", invalid_postcode, 10)
  end

  context "GET show" do
    context "for live content" do
      should "set the cache expiry headers" do
        get :show, params: { slug: "passport-interview-office" }

        honours_content_store_ttl
      end

      should "not show location error" do
        get :show, params: { slug: "passport-interview-office" }

        assert_equal @controller.view_assigns["location_error"], nil
      end
    end
  end

  context "POST show" do
    context "with invalid postcode" do
      should "will show location error" do
        post :show, params: { slug: "passport-interview-office", postcode: "1234" }

        assert_equal @controller.view_assigns["location_error"], nil
      end
    end
  end
end
