require File.expand_path('production.rb', File.dirname(__FILE__))
Frontend::Application.configure do
  config.middleware.delete Slimmer::App
  config.middleware.use Slimmer::App, :template_host => "/data/vhost/static.#{Rails.env}.alphagov.co.uk/current/public/templates"
end
