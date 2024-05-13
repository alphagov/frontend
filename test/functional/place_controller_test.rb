require "test_helper"
require "gds_api/test_helpers/places_manager"

class PlaceControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::PlacesManager

  valid_postcode = "SW1A 2AA"
  invalid_postcode = "1234 2AA"

  setup do
    content_store_has_random_item(base_path: "/slug", schema: "place", details: { "place_type" => "slug" })
    stub_places_manager_has_places_for_postcode([{
      "access_notes" => "The London Passport Office is fully accessible to wheelchair users. ",
      "address1" => nil,
      "address2" => "89 Eccleston Square",
      "email" => nil,
      "fax" => nil,
      "general_notes" => "Monday to Saturday 8.00am - 6.00pm. ",
      "location" => {
        "longitude" => -0.14411606838362725,
        "latitude" => 51.49338734529598,
      },
      "name" => "London IPS Office",
      "phone" => "0800 123 4567",
      "postcode" => "SW1V 1PN",
      "text_phone" => nil,
      "town" => "London",
      "url" => "http://www.example.com/london_ips_office",
    }], "slug", valid_postcode, 10, nil)
    query_hash = { "postcode" => invalid_postcode, "limit" => Frontend::PLACES_MANAGER_QUERY_LIMIT }
    return_data = { "error" => ImminenceResponse::INVALID_POSTCODE }
    stub_places_manager_places_request("slug", query_hash, return_data, 400)
  end

  context "GET show" do
    context "for live content" do
      should "set the cache expiry headers" do
        get :show, params: { slug: "slug" }

        honours_content_store_ttl
      end

      should "not show location error" do
        get :show, params: { slug: "slug" }

        assert_nil @controller.view_assigns["location_error"]
      end
    end
  end

  context "POST find" do
    context "with valid postcode" do
      should "not show location error" do
        post :find, params: { slug: "slug", postcode: valid_postcode }

        assert_nil @controller.view_assigns["location_error"]
      end
    end
    context "with invalid postcode" do
      should "show location error" do
        post :find, params: { slug: "slug", postcode: invalid_postcode }
        assert_equal @controller.view_assigns["location_error"].postcode_error, LocationError.new(ImminenceResponse::INVALID_POSTCODE).postcode_error
      end
    end
  end
end
