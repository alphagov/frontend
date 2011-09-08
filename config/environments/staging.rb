require File.expand_path('production.rb', File.dirname(__FILE__))

Publisher::Application.configure do
  config.action_mailer.default_url_options = { :host => "demo.alphagov.co.uk" }
end
