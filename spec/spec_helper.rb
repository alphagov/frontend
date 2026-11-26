require "simplecov"

unless ENV["DISABLE_SIMPLECOV"]
  SimpleCov.start "rails" do
    cover_views
    enable_coverage :branch
    minimum_coverage 95
  end
end

ENV["RAILS_ENV"] = "test"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
require "capybara/rails"
require "timecop"
require "webmock/rspec"
WebMock.disable_net_connect!(allow_localhost: true)

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

GovukTest.configure
Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Options.chrome(
    browser_version: "157",
    "goog:loggingPrefs": { browser: "ALL" },
  )
  options.add_argument("--headless=new")
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

GovukAbTesting.configure do |config|
  config.acceptance_test_framework = :capybara
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.include FactoryBot::Syntax::Methods
  config.include Capybara::DSL, capybara: true, visual_regression: true
  config.filter_run_excluding visual_regression: true
  config.include ContentStoreHelpers, type: :request
  config.include ContentStoreHelpers, type: :system
  config.include ContentStoreHelpers, type: :visual_regression

  config.include ComponentHelpers, type: :view

  config.include ActiveSupport::Testing::TimeHelpers

  config.before(:each, type: :system) do
    driven_by :rack_test
    Rails.application.config.emergency_banner_redis_client = instance_double(Redis, hgetall: {})
  end

  config.before(:each, type: :request) do
    Rails.application.config.emergency_banner_redis_client = instance_double(Redis, hgetall: {})
  end
end
