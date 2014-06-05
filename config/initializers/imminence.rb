require 'gds_api/imminence'

Frontend.imminence_api = GdsApi::Imminence.new( Plek.current.find('imminence') )
