require_relative 'test_helper'
require 'capybara/rails'
require 'capybara/poltergeist'

require 'gds_api/test_helpers/publisher'
require 'gds_api/test_helpers/content_api'
require 'gds_api/test_helpers/imminence'
require 'slimmer/test'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include GdsApi::TestHelpers::Publisher
  include GdsApi::TestHelpers::ContentApi
  include GdsApi::TestHelpers::Imminence

  def teardown
    Capybara.use_default_driver
  end

  def publisher_api_response(slug)
    json = File.read(Rails.root.join("test/fixtures/#{slug}.json"))
    JSON.parse(json)
  end

  def setup_api_responses(slug, options = {})
    publication_info = publisher_api_response(slug)
    publication_exists(publication_info, options)
    content_api_has_an_artefact(slug)
  end

  def stub_location_request(postcode, response)
    defaults = { "shortcuts" => {} }
    stub_request(:get, "http://mapit.test.gov.uk/postcode/" + postcode.sub(' ','+') + ".json").to_return(:body => defaults.merge(response).to_json)
    stub_request(:get, "http://mapit.test.gov.uk/postcode/partial/" + postcode.split(' ').first + ".json").to_return(:body => response.slice("wgs84_lat","wgs84_lon").to_json)
  end
end

Capybara.javascript_driver = :poltergeist
