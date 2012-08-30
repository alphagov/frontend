require_relative 'test_helper'
require 'capybara/rails'

require 'gds_api/test_helpers/publisher'
require 'gds_api/test_helpers/panopticon'
require 'gds_api/test_helpers/imminence'
require 'slimmer/test'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include GdsApi::TestHelpers::Publisher
  include GdsApi::TestHelpers::Panopticon
  include GdsApi::TestHelpers::Imminence

  def teardown
    Capybara.use_default_driver
  end
end

Capybara.javascript_driver = :webkit
