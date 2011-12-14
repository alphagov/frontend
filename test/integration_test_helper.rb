require 'test_helper'
require 'capybara/rails'

require 'webmock/test_unit'
WebMock.disable_net_connect!(:allow_localhost => true)

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end

Capybara.default_driver = :webkit
Capybara.app = Rack::Builder.new do
  map "/" do
    run Capybara.app
  end
end
