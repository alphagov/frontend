require "pact/provider/rspec"
require "webmock/rspec"
require "gds_api/test_helpers/content_store"

Pact.configure do |config|
  config.reports_dir = "spec/reports/pacts"
  config.include WebMock::API
  config.include WebMock::Matchers
  config.include GdsApi::TestHelpers::ContentStore
end

Pact.service_provider "Bank Holidays API" do
  honours_pact_with "GDS API Adapters" do
    pact_uri "../gds-api-adapters/spec/pacts/gds_api_adapters-bank_holidays_api.json"
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
