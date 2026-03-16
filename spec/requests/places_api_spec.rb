require "gds_api/test_helpers/places_manager"

RSpec.describe "Places API" do
  include GdsApi::TestHelpers::PlacesManager

  let(:service_slug) { "driving-test-centres" }
  let(:allowed_service_slugs) { [service_slug] }

  let(:places) do
    [
      {
        "name" => "A place",
        "source_address" => "Hello Town, AB12 3CD",
        "location" => {
          "longitude" => "51",
          "latitude" => "-0.01",
        },
        "general_notes" => "<div>Hello</div>",
      },
    ]
  end

  before do
    stub_places_manager_places_request(
      service_slug,
      {},
      {
        status: "ok",
        content: "places",
        places:,
      },
    )
    Rails.application.config.allowed_geojson_slugs = allowed_service_slugs
  end

  describe "geojson" do
    it "returns geojson formatted data" do
      get "/api/places/#{service_slug}.geojson"

      expect(response).to have_http_status(:ok)
      expect(response.headers["content-type"]).to eq("application/geo+json; charset=utf-8")
      expect(response.body).to eq("{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[\"51\",\"-0.01\"]},\"properties\":{\"name\":\"A place\",\"description\":\"<div>Hello</div>\"}}]}")
    end

    context "when asking for a non-allowed slug" do
      let(:allowed_service_slugs) { [] }

      it "returns 404" do
        get "/api/places/#{service_slug}.geojson"

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
