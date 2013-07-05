require 'gds_api/base'
require 'gds_api/content_api'

GdsApi::Base.logger = Logger.new(Rails.root.join("log/#{Rails.env}.api_client.log"))

# This file is overwritten on deployment, so this only applies to development.
GdsApi::Base.default_options = { disable_cache: true }

Frontend.detailed_guidance_content_api = GdsApi::ContentApi.new("#{Plek.current.find('whitehall')}/api/specialist/")

# Note that copies of this exist in both preview and production
# to_upload directories, so make sure your changes propagate there.
