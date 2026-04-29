# rubocop:disable Rails/ApplicationController
module Api
  class PlacesController < ActionController::Base
    def show
      return render json: {}, status: :not_found unless allowed_slugs.include? params[:service_slug]

      respond_to do |format|
        format.geojson do
          render json: geojson_from_service(params[:service_slug]), status: :ok
        end
      end
    end

  private

    def allowed_slugs
      Rails.application.config.allowed_geojson_slugs
    end

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
          description: place["general_notes"],
        },
      }
    end
  end
end
# rubocop:enable Rails/ApplicationController
