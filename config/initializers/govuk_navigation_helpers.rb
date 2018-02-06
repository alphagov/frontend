require 'govuk_navigation_helpers'

GovukNavigationHelpers.configure do |config|
  config.error_handler = GovukError
  config.statsd = GovukStatsd.client
end
