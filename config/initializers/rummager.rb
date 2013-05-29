require 'gds_api/rummager'
rummager_host = ENV["RUMMAGER_HOST"] || Plek.current.find('search')
Frontend.mainstream_search_client = GdsApi::Rummager.new(rummager_host + '/mainstream')
Frontend.detailed_guidance_search_client = GdsApi::Rummager.new(rummager_host + '/detailed')
Frontend.government_search_client = GdsApi::Rummager.new(rummager_host + '/government')
