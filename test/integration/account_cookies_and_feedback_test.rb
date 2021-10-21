require "integration_test_helper"
require "gds_api/test_helpers/account_api"
require "govuk_personalisation/test_helpers/features"

class AccountCookiesAndFeedbackTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::AccountApi
  include GovukPersonalisation::TestHelpers::Features

  setup { mock_logged_in_session("foo") }

  should "queries account-api for the user's consent settings" do
    stub = stub_account_api_has_attributes(attributes: %w[cookie_consent feedback_consent])

    visit account_cookies_and_feedback_path

    assert_not page.has_content?("Your feedback and cookie settings have been changed.")
    assert_requested stub
  end

  should "saves the attributes and redirects to update the cookie policy" do
    stub_account_api_has_attributes(attributes: %w[cookie_consent feedback_consent])
    stub = stub_account_api_set_attributes(attributes: { cookie_consent: false, feedback_consent: false })

    visit account_cookies_and_feedback_path
    click_on "Save"

    assert_includes current_url, "cookie_consent=reject"
    assert page.has_content?("Your feedback and cookie settings have been changed.")
    assert_requested stub
  end
end
