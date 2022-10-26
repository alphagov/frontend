require "test_helper"
require "govuk_schemas/assert_matchers"

class HomepagePublisherTest < ActiveSupport::TestCase
  include GovukSchemas::AssertMatchers

  test ".publish! works without errors" do
    # TODO: add test helpers to govuk_schemas and use that
    content_request = stub_request(:put, "http://publishing-api.dev.gov.uk/v2/content/f3bbdec2-0e62-4520-a7fd-6ffd5d36e03a")
      .to_return(status: 200)
    publish_request = stub_request(:post, "http://publishing-api.dev.gov.uk/v2/content/f3bbdec2-0e62-4520-a7fd-6ffd5d36e03a/publish")
      .to_return(status: 200)
    patch_links_request = stub_request(:patch, "http://publishing-api.dev.gov.uk/v2/links/f3bbdec2-0e62-4520-a7fd-6ffd5d36e03a")
      .to_return(status: 200)

    stub_api = GdsApi::PublishingApi.new(Plek.find("publishing-api"))

    mock_logger = mock
    mock_logger.expects(:info).returns("Publishing exact route /, routing to frontend")

    HomepagePublisher.publish!(stub_api, mock_logger)

    assert_requested(
      content_request.with do |req|
        assert_valid_against_publisher_schema(JSON.parse(req.body), "homepage")
      end,
    )

    assert_requested(publish_request)

    expected_links = {
      "organisations" => %w[af07d5a5-df63-4ddc-9383-6a666845ebe9],
      "primary_publishing_organisation" => %w[af07d5a5-df63-4ddc-9383-6a666845ebe9],
    }
    assert_requested(
      patch_links_request.with do |req|
        assert_equal expected_links, JSON.parse(req.body)["links"]
      end,
    )
  end
end
