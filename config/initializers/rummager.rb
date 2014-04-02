require 'gds_api/rummager'
rummager_host = ENV["RUMMAGER_HOST"] || Plek.current.find('search')
Frontend.organisations_search_client = GdsApi::Rummager.new(rummager_host)

Frontend.combined_search_client = GdsApi::Rummager.new(rummager_host + '/govuk')
Frontend.search_client = GdsApi::Rummager.new(rummager_host)
