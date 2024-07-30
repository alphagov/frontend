require "pact/provider/rspec"
require "webmock/rspec"
require "gds_api/test_helpers/content_store"
require ::File.expand_path("../../config/environment", __dir__)

Pact.configure do |config|
  config.reports_dir = "spec/reports/pacts"
  config.include WebMock::API
  config.include WebMock::Matchers
  config.include GdsApi::TestHelpers::ContentStore
end

WebMock.allow_net_connect!

def url_encode(str)
  ERB::Util.url_encode(str)
end

Pact.service_provider "Bank Holidays API" do
  honours_pact_with "GDS API Adapters" do
    if ENV["PACT_URI"]
      pact_uri(ENV["PACT_URI"])
    else
      base_url = "https://govuk-pact-broker-6991351eca05.herokuapp.com"
      path = "pacts/provider/#{url_encode(name)}/consumer/#{url_encode(consumer_name)}"
      version_modifier = "versions/#{url_encode(ENV.fetch('PACT_CONSUMER_VERSION', 'master'))}"

      pact_uri("#{base_url}/#{path}/#{version_modifier}")
    end
  end
end

Pact.provider_states_for "GDS API Adapters" do
  provider_state "there is a list of all bank holidays" do
    set_up do
      content_item = {
        base_path: "/bank-holidays",
        schema_name: "calendar",
        document_type: "calendar",
      }
      stub_content_store_has_item("/bank-holidays", content_item)
    end
  end
end
