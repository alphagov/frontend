require_relative 'test_helper'
require 'capybara/rails'
require 'capybara/poltergeist'

require 'gds_api/test_helpers/content_api'
require 'slimmer/test'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include GdsApi::TestHelpers::ContentApi

  def teardown
    Capybara.use_default_driver
    WebMock.reset!
  end

  def content_api_response(slug)
    json = File.read(Rails.root.join("test/fixtures/#{slug}.json"))
    JSON.parse(json)
  end

  def setup_api_responses(slug, options = {})
    artefact = content_api_response(slug)
    content_api_has_an_artefact_with_optional_location(slug, artefact)
  end

  def stub_location_request(postcode, response, status = 200)
    defaults = { "shortcuts" => {} }
    stub_request(:get, /api.geonames.org/)
    stub_request(:get, "http://mapit.dev.gov.uk/postcode/" + postcode.sub(' ','+') + ".json").to_return(:body => defaults.merge(response).to_json, :status => status)
    stub_request(:get, "http://mapit.dev.gov.uk/postcode/partial/" + postcode.split(' ').first + ".json").to_return(:body => response.slice("wgs84_lat","wgs84_lon").to_json, :status => status)
  end

  def content_api_has_an_artefact_with_optional_location(slug, body = artefact_for_slug(slug))
    GdsApi::TestHelpers::ContentApi::ArtefactStub.new(slug)
        .with_response_body(body)
        .stub
    GdsApi::TestHelpers::ContentApi::ArtefactStub.new(slug)
        .with_query_parameters(latitude: -0.18832238262617113, longitude: 51.112777245292826)
        .with_response_body(body)
        .stub
  end

  def assert_current_url(path_with_query, options = {})
    expected = URI.parse(path_with_query)
    current = URI.parse(current_url)
    assert_equal expected.path, current.path
    unless options[:ignore_query]
      assert_equal Rack::Utils.parse_query(expected.query), Rack::Utils.parse_query(current.query)
    end
  end
end

Capybara.javascript_driver = :poltergeist
