Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.assets.debug = true

  config.eager_load = false

  # Log Action Mailer emails instead of sending them to Notify
  config.action_mailer.delivery_method = :file
  config.action_mailer.default_options = { from: "test@example.com" }

  config.hosts << "frontend.dev.gov.uk"
end
