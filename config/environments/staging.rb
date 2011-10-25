require File.expand_path('production.rb', File.dirname(__FILE__))
Frontend::Application.configure do
  config.middleware.delete Slimmer::App
  config.middleware.use Slimmer::App, :asset_host => "http://static.staging.alphagov.co.uk"
end
