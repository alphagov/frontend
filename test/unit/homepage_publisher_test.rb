require 'test_helper'
require 'govuk-content-schema-test-helpers/test_unit'

class HomepagePublisherTest < ActiveSupport::TestCase
  include GovukContentSchemaTestHelpers::TestUnit

  test ".publish! works without errors" do
    # TODO: add test helpers to govuk_schemas and use that
    GovukContentSchemaTestHelpers.configure do |config|
      config.schema_type = 'publisher_v2'
      config.project_root = Rails.root
    end

    content_request = stub_request(:put, "http://publishing-api.dev.gov.uk/v2/content/f3bbdec2-0e62-4520-a7fd-6ffd5d36e03a").
      to_return(status: 200)
    publish_request = stub_request(:post, "http://publishing-api.dev.gov.uk/v2/content/f3bbdec2-0e62-4520-a7fd-6ffd5d36e03a/publish").
      to_return(status: 200)

    stub_api = GdsApi::PublishingApiV2.new(Plek.find("publishing-api"))

    HomepagePublisher.publish!(stub_api, stub(:info))

    assert_requested(
      content_request.with do |req|
        assert_valid_against_schema(JSON.parse(req.body), 'homepage')
      end
    )

    assert_requested(publish_request)

    GovukContentSchemaTestHelpers.configure do |config|
      config.schema_type = 'frontend'
      config.project_root = Rails.root
    end
  end
end
