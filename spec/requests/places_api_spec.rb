require "gds_api/test_helpers/places_manager"

RSpec.describe "Places API" do
  include GdsApi::TestHelpers::PlacesManager

  let(:service_slug) { "driving-test-centres" }
  let(:places) do
    [
      {
        "name" => "A place",
        "source_address" => "Hello Town, AB12 3CD",
        "location" => {
          "longitude" => "51",
          "latitude" => "-0.01",
        },
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
  end

  describe "geojson" do
    it "returns geojson formatted data" do
      get "/api/places/#{service_slug}.geojson"

      expect(response).to have_http_status(:ok)
      expect(response.headers["content-type"]).to eq("application/geo+json; charset=utf-8")
      expect(response.body).to eq("{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[\"51\",\"-0.01\"]},\"properties\":{\"name\":\"A place\",\"description\":\"Hello Town, AB12 3CD\"}}]}")
    end
  end
end
