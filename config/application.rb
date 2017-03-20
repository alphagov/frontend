require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie"

if defined?(Bundler)
  Bundler.require(*Rails.groups)
end

module Frontend
  class Application < Rails::Application
    require 'frontend'

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/app/presenters #{config.root}/lib)

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Enable the asset pipeline
    config.assets.enabled = true

    config.assets.precompile += %w(
      views/travel-advice.js
      frontend.js
      tour.js
      application.css
      application-ie6.css
      application-ie7.css
      application-ie8.css
      mouseflow.js
    )

    # Path within public/ where assets are compiled to
    config.assets.prefix = "/frontend"

    # Paths used by helpers when generating links to assets
    config.action_controller.assets_dir = Rails.root.join 'public/frontend'
    config.action_controller.javascripts_dir = Rails.root.join 'public/frontend/javascripts'
    config.action_controller.stylesheets_dir = Rails.root.join 'public/frontend/stylesheets'

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :postcode]

    # Disable Rack::Cache
    config.action_dispatch.rack_cache = nil

    # Disable Content Negotiation
    config.action_dispatch.ignore_accept_header = true

    # Override Rails 4 default which restricts framing to SAMEORIGIN.
    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL'
    }

    # Google Analytics dimension assigned to the benchmarking A/B test
    config.benchmarking_ab_test_dimension = 49
  end
end
