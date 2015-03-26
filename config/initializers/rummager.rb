require 'gds_api/rummager'
require 'search_api'
rummager_host = ENV["RUMMAGER_HOST"] || Plek.current.find('search')

Frontend.search_client = SearchAPI.new(GdsApi::Rummager.new(rummager_host))
