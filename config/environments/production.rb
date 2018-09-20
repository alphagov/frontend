require 'plek'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  config.log_level = :info

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.eager_load = true

  # Set GOVUK_ASSET_ROOT for heroku - for review apps we have the hostname set
  # at the time of the app being built so can't be set up in the app.json
  if !ENV.include?('GOVUK_ASSET_ROOT') && ENV['HEROKU_APP_NAME']
    ENV['GOVUK_ASSET_ROOT'] = "https://#{ENV['HEROKU_APP_NAME']}.herokuapp.com"
  end

  # Enable serving of images, stylesheets, and javascripts from an asset server
  config.action_controller.asset_host = ENV['GOVUK_ASSET_ROOT']

  config.assets.compress = true
  config.assets.digest = true
  config.assets.js_compressor = :uglifier

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = ENV['HEROKU_APP_NAME'] ? nil : "X-Sendfile"
end
