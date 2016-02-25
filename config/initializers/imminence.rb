require 'gds_api/imminence'

Frontend.imminence_api = GdsApi::Imminence.new( Plek.current.find('imminence') )

Frontend::IMMINENCE_QUERY_LIMIT = 10
