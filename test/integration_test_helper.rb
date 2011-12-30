require 'test_helper'
require 'capybara/rails'

require 'gds_api/test_helpers/publisher'
require 'gds_api/test_helpers/panopticon'
require 'gds_api/test_helpers/imminence'
#require 'slimmer/test'

class ActionController::Base
  before_filter proc {
    response.headers[Slimmer::SKIP_HEADER] = "true"
  }
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include GdsApi::TestHelpers::Publisher
  include GdsApi::TestHelpers::Panopticon
  include GdsApi::TestHelpers::Imminence

end

Capybara.default_driver = :webkit
Capybara.app = Rack::Builder.new do
  map "/" do
    run Capybara.app
  end
end
