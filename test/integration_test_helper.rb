require_relative 'test_helper'
require 'capybara/rails'
require 'capybara/poltergeist'

require 'gds_api/test_helpers/content_api'
require 'slimmer/test'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include GdsApi::TestHelpers::ContentApi

  def setup
    super
    # Stub website_root to match test fixtures
    Plek.any_instance.stubs(:website_root).returns("https://www.gov.uk")
  end

  def teardown
    Capybara.use_default_driver
    WebMock.reset!
  end

  def content_api_response(slug, options = {})
    options[:file] ||= "#{slug}.json"
    json = File.read(Rails.root.join("test/fixtures/#{options[:file]}"))
    JSON.parse(json)
  end

  def setup_api_responses(slug, options = {})
    artefact = content_api_response(slug, options)
    content_api_has_an_artefact_with_optional_location(slug, artefact)
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

  def content_api_has_a_draft_artefact(slug, version, body = artefact_for_slug(slug))
    GdsApi::TestHelpers::ContentApi::ArtefactStub.new(slug)
        .with_query_parameters(edition: version)
        .with_response_body(body)
        .stub
  end

  def assert_page_has_content(text)
    assert page.has_content?(text), %(expected there to be content #{text} in #{page.text.inspect})
  end

  def assert_current_url(path_with_query, options = {})
    expected = URI.parse(path_with_query)
    wait_until { expected.path == URI.parse(current_url).path }
    current = URI.parse(current_url)
    assert_equal expected.path, current.path
    unless options[:ignore_query]
      assert_equal Rack::Utils.parse_query(expected.query), Rack::Utils.parse_query(current.query)
    end
  end

  def assert_govuk_component_present(options)
    component = find("test-govuk-component[data-template='#{options[:template]}']")
    yield JSON.parse(component.text())
  end

  # Adapted from http://www.elabs.se/blog/53-why-wait_until-was-removed-from-capybara
  def wait_until
    if Capybara.current_driver == Capybara.javascript_driver
      begin
        Timeout.timeout(Capybara.default_wait_time) do
          sleep(0.1) until yield
        end
      rescue TimeoutError
      end
    end
  end

  def self.with_javascript
    context "with javascript" do
      setup do
        Capybara.current_driver = Capybara.javascript_driver
      end

      yield
    end
  end

  def self.without_javascript
    context "without javascript" do
      yield
    end
  end

  def self.with_and_without_javascript
    without_javascript do
      yield
    end

    with_javascript do
      yield
    end
  end
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, { phantomjs_options: ['--ssl-protocol=TLSv1'] })
end

Capybara.javascript_driver = :poltergeist
