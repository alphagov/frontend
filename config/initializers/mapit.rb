require 'gds_api/mapit'
require 'plek'

# This will be overriden at deploy
# In development, use MySociety's mapit install

if Rails.env.development?
  Frontend.mapit_api = GdsApi::Mapit.new( ENV['MAPIT_ENDPOINT'] || 'http://mapit.mysociety.org/')
else
  Frontend.mapit_api = GdsApi::Mapit.new( Plek.current.find('mapit') )
end
