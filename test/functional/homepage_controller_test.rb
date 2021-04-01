require "test_helper"

class HomepageControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  context "loading the homepage" do
    setup do
      stub_orgs = {
        details: {
          ordered_ministerial_departments: Array.new(1, {}),
          ordered_agencies_and_other_public_bodies: Array.new(1, {}),
        },
      }
      stub_content_store_has_item("/", schema: "special_route")
      stub_content_store_has_item("/government/organisations", stub_orgs)
    end

    should "respond with success" do
      get :index
      assert_response :success
    end

    should "set correct expiry headers" do
      get :index
      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end
  end
end
