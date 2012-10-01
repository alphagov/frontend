require 'gds_api/rummager'
Frontend.mainstream_search_client = GdsApi::Rummager.new(Plek.current.find('search') + '/mainstream')
Frontend.detailed_guidance_search_client = GdsApi::Rummager.new(Plek.current.find('search') + '/detailed')
