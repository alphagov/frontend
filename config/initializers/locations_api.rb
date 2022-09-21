require "gds_api/locations_api"
require "plek"

Frontend.locations_api = GdsApi::LocationsApi.new(Plek.new.find("locations-api"))
