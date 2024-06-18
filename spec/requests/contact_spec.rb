require "gds_api/test_helpers/support_api"
require "gds_zendesk/test_helpers"

RSpec.describe "Contact", type: :request do
  include GdsApi::TestHelpers::SupportApi
  include GDSZendesk::TestHelpers

  def response_contains(request, field, expected_value)
    response = JSON.parse(request.body)
    raw_body = response["ticket"]["comment"]["body"]
    actual_value = raw_body.match(/#{Regexp.quote(field)}\n([^\[]+)/)
    actual_value = actual_value[1].strip unless actual_value.nil?
    actual_value == expected_value
  end

  before do
    self.valid_zendesk_credentials = ZENDESK_CREDENTIALS
  end

  it "should still work even if the request doesn't have correct form params" do
    post "/contact/govuk", params: {}

    expect(response.body).to include("Please check the form")
  end

  it "should include the user agent if available" do
    zendesk_has_user(email: "test@test.com", suspended: false)
    stub_zendesk_ticket_creation

    # Using Rack::Test to allow setting the user agent.
    params = {
      contact: {
        query: "report-problem",
        link: "www.test.com",
        location: "specific",
        name: "test name",
        email: "test@test.com",
        textdetails: "test text details",
      },
    }
    headers = { "HTTP_USER_AGENT" => "T1000 (Bazinga)" }
    post("/contact/govuk", params:, headers:)

    assert_requested(:post, %r{/tickets}) do |request|
      response_contains(request, "[User agent]", "T1000 (Bazinga)")
    end
  end

  it "should include the Access-Control-Allow-Origin if the request came from .gov.uk" do
    zendesk_has_user(email: "test@test.com", suspended: false)
    stub_zendesk_ticket_creation

    params = {
      contact: {
        query: "report-problem",
        link: "www.test.com",
        location: "specific",
        name: "test name",
        email: "test@test.com",
        textdetails: "test text details",
      },
    }
    headers = { "ORIGIN" => "https://assets.publishing.service.gov.uk" }
    post("/contact/govuk", params:, headers:)

    assert_requested(:post, %r{/tickets}) do |_request|
      response.headers["Access-Control-Allow-Origin"] == "https://assets.publishing.service.gov.uk"
    end
  end

  it "shouldn't include the Access-Control-Allow-Origin if the request did not come from .gov.uk" do
    zendesk_has_user(email: "test@test.com", suspended: false)
    stub_zendesk_ticket_creation

    params = {
      contact: {
        query: "report-problem",
        link: "www.test.com",
        location: "specific",
        name: "test name",
        email: "test@test.com",
        textdetails: "test text details",
      },
    }

    headers = { "ORIGIN" => "https://not-gov.uk" }

    post("/contact/govuk", params:, headers:)

    assert_requested(:post, %r{/tickets}) do |_request|
      response.headers["Access-Control-Allow-Origin"].nil?
    end
  end

  it "should include the referrer if present in the contact params" do
    zendesk_has_user(email: "test@test.com", suspended: false)
    stub_zendesk_ticket_creation

    params = {
      contact: {
        query: "report-problem",
        link: "www.test.com",
        location: "specific",
        name: "test name",
        email: "test@test.com",
        textdetails: "test text details",
        referrer: "http://www.dev.gov.uk/referring_url",
      },
    }
    post("/contact/govuk", params:)

    assert_requested(:post, %r{/tickets}) do |request|
      response_contains(request, "[Referrer]", "http://www.dev.gov.uk/referring_url")
    end
  end

  it "should include the referrer if present in the post" do
    zendesk_has_user(email: "test@test.com", suspended: false)
    stub_zendesk_ticket_creation

    params = {
      contact: {
        query: "report-problem",
        link: "www.test.com",
        location: "specific",
        name: "test name",
        email: "test@test.com",
        textdetails: "test text details",
      },
      referrer: "http://www.dev.gov.uk/referring_url",
    }
    post("/contact/govuk", params:)

    assert_requested(:post, %r{/tickets}) do |request|
      response_contains(request, "[Referrer]", "http://www.dev.gov.uk/referring_url")
    end
  end

  it "should include the referrer from the request" do
    zendesk_has_user(email: "test@test.com", suspended: false)
    stub_zendesk_ticket_creation

    params = {
      contact: {
        query: "report-problem",
        link: "www.test.com",
        location: "specific",
        name: "test name",
        email: "test@test.com",
        textdetails: "test text details",
      },
    }

    post "/contact/govuk", params:, headers: { "HTTP_REFERER" => "http://www.dev.gov.uk/referring_url" }

    assert_requested(:post, %r{/tickets}) do |request|
      response_contains(request, "[Referrer]", "http://www.dev.gov.uk/referring_url")
    end
  end
end
