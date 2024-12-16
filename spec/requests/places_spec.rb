require "gds_api/test_helpers/places_manager"

RSpec.describe "Places" do
  include GdsApi::TestHelpers::PlacesManager

  let(:valid_postcode) { "SW1A 2AA" }
  let(:invalid_postcode) { "1234 2AA" }

  before do
    content_store_has_random_item(base_path: "/slug", schema: "place", details: { "place_type" => "slug" })
    stub_places_manager_has_places_for_postcode(
      [
        {
          "access_notes" => "The London Passport Office is fully accessible to wheelchair users. ",
          "address1" => nil,
          "address2" => "89 Eccleston Square",
          "email" => nil,
          "fax" => nil,
          "general_notes" => "Monday to Saturday 8.00am - 6.00pm. ",
          "location" => { "longitude" => -0.14411606838362725, "latitude" => 51.49338734529598 },
          "name" => "London IPS Office",
          "phone" => "0800 123 4567",
          "postcode" => "SW1V 1PN",
          "text_phone" => nil,
          "town" => "London",
          "url" => "http://www.example.com/london_ips_office",
        },
      ],
      "slug",
      valid_postcode,
      10,
      nil,
    )
    query_hash = { "postcode" => invalid_postcode, "limit" => Frontend::PLACES_MANAGER_QUERY_LIMIT }
    return_data = { "error" => PlacesManagerResponse::INVALID_POSTCODE }
    stub_places_manager_places_request("slug", query_hash, return_data, 400)
  end

  describe "GET 'a place content item'" do
    it "sets the cache expiry headers" do
      get "/slug"

      expect(response).to honour_content_store_ttl
    end

    it "does not show location error" do
      get "/slug"

      expect(controller.view_assigns["location_error"]).to be_nil
    end
  end

  describe "POST 'a postcode'" do
    context "with valid postcode" do
      it "does not show location error" do
        post "/slug", params: { postcode: valid_postcode }

        expect(controller.view_assigns["location_error"]).to be_nil
      end
    end

    context "with invalid postcode" do
      it "shows location error" do
        post "/slug", params: { postcode: invalid_postcode }

        expect(controller.view_assigns["location_error"].postcode_error).to eq(LocationError.new(PlacesManagerResponse::INVALID_POSTCODE).postcode_error)
      end
    end
  end
end
