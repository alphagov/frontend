require 'gds_api/mapit'
require 'plek'

Frontend.mapit_api = GdsApi::Mapit.new(Plek.current.find('mapit'))
