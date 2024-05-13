require "gds_api/places_manager"

Frontend.places_manager_api = GdsApi::PlacesManager.new(Plek.new.find("places-manager"))

Frontend::PLACES_MANAGER_QUERY_LIMIT = 10
