require "integration_test_helper"
require "gds_api/test_helpers/account_api"
require "gds_api/test_helpers/email_alert_api"
require "govuk_personalisation/test_helpers/features"

class AccountHomeTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::AccountApi
  include GdsApi::TestHelpers::EmailAlertApi
  include GovukPersonalisation::TestHelpers::Features

  setup do
    mock_logged_in_session("session-id")
    stub_account_api_user_info
    stub_email_alert_api_authenticate_subscriber_by_govuk_account(
      "session-id",
      "subscriber-id",
      "example@example.com",
    )
    stub_email_alert_api_does_not_have_subscriber_subscriptions("subscriber-id")
  end

  should "show only the no email panel for an account with no linked services and no email subscriptions" do
    visit account_home_path
    assert page.has_content?("You do not currently have any GOV.UK email subscriptions")
    assert_not page.has_content?("Brexit checker results")
  end

  should "show the manage emails panel for an account with email subscriptions" do
    stub_email_alert_api_has_subscriber_subscriptions(
      "subscriber-id",
      "example@example.com",
      subscriptions: [{ "foo": "bar" }],
    )

    visit account_home_path
    assert page.has_content?("See and manage the emails you get about updates to pages on GOV.UK")
  end
end
