require "gds_api/mapit"
require "plek"

Frontend.mapit_api = GdsApi::Mapit.new(Plek.new.find("mapit"))
