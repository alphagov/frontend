require "gds_api/imminence"

Frontend.imminence_api = GdsApi::Imminence.new(Plek.new.find("imminence"))

Frontend::IMMINENCE_QUERY_LIMIT = 10
