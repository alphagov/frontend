require File.expand_path('production.rb', File.dirname(__FILE__))
Frontend::Application.configure do
  config.action_mailer.default_url_options = { :host => "demo.alphagov.co.uk" }
  config.action_mailer.smtp_settings = {:enable_starttls_auto => false}
end
