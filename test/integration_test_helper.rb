require 'test_helper'
require 'capybara/rails'

require 'gds_api/test_helpers/publisher'
require 'gds_api/test_helpers/panopticon'
require 'gds_api/test_helpers/imminence'
require 'slimmer/test'

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

  def publisher_api_response(slug)
    json = File.read(Rails.root.join("test/fixtures/#{slug}.json"))
    JSON.parse(json)
  end

  def setup_api_responses(slug, options = {})
    artefact_info = {
      "slug" => slug,
      "section" => "transport"
    }
    publication_info = publisher_api_response(slug)
    publication_exists(publication_info, options)
    panopticon_has_metadata(artefact_info)
  end
end

Capybara.default_driver = :webkit
