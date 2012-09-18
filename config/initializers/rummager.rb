require 'gds_api/rummager'
Frontend.search_client = GdsApi::Rummager.new(Plek.current.find('search'))