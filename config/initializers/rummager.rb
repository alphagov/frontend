require 'gds_api/rummager'
rummager_host = ENV["RUMMAGER_HOST"] || Plek.current.find('search')

Frontend.search_client = GdsApi::Rummager.new(rummager_host)
