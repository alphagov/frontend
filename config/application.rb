require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "active_support/time"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "rails/test_unit/railtie"
require_relative "../lib/sanitiser/strategy"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Frontend
  class Application < Rails::Application
    include GovukPublishingComponents::AppHelpers::AssetHelper
    # Initialize configuration defaults for originally generated Rails version.
    require "frontend"
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks sanitiser])

    # Custom directories with classes and modules you want to be autoloadable.
    config.eager_load_paths += %W[#{config.root}/app/presenters]

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    locale_files = Dir[Rails.root.join("config/locales/*.yml")]
    available_locales = locale_files.map do |file|
      File.basename(file, ".yml").to_sym
    end
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true
    config.i18n.available_locales = available_locales

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Enable the asset pipeline
    config.assets.enabled = true

    # Path within public/ where assets are compiled to
    config.assets.prefix = "/assets/frontend"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += %i[password postcode]

    # Disable Rack::Cache
    config.action_dispatch.rack_cache = nil

    # Disable Content Negotiation
    config.action_dispatch.ignore_accept_header = true

    # Override Rails 4 default which restricts framing to SAMEORIGIN.
    config.action_dispatch.default_headers = {
      "X-Frame-Options" => "ALLOWALL",
    }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Using a sass css compressor causes a scss file to be processed twice
    # (once to build, once to compress) which breaks the usage of "unquote"
    # to use CSS that has same function names as SCSS such as max.
    # https://github.com/alphagov/govuk-frontend/issues/1350
    config.assets.css_compressor = nil

    # Protect from "invalid byte sequence in UTF-8" errors,
    # when a query or a cookie is a string with incorrect UTF-8 encoding.
    config.middleware.insert_before(
      0,
      Rack::UTF8Sanitizer,
      only: %w[QUERY_STRING],
      strategy: Sanitiser::Strategy,
    )
  end
end
