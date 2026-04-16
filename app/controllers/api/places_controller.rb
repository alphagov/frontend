# rubocop:disable Rails/ApplicationController
module Api
  class PlacesController < ActionController::Base
    def show
      respond_to do |format|
        format.geojson do
          render json: geojson_from_service("driving-test-centres"), status: :ok
        end
      end
    end

  private

    def geojson_from_service(service_slug)
      url = Frontend.places_manager_api.api_url(service_slug, {})
      places_manager_response = Frontend.places_manager_api.get_json(url)
      places_manager_data = places_manager_response.to_hash
      places = places_manager_data["places"]

      {
        type: "FeatureCollection",
        features: places.map { |place| map_to_feature(place) },
      }
    end

    def map_to_feature(place)
      {
        type: "Feature",
        geometry: {
          type: "Point",
          coordinates: [
            place["location"]["longitude"],
            place["location"]["latitude"],
          ],
        },
        properties: {
          name: place["name"],
          description: place["source_address"],
        },
      }
    end
  end
end
# rubocop:enable Rails/ApplicationController
