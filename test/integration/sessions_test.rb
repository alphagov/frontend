require_relative "../integration_test_helper"
require "gds_api/test_helpers/account_api"
require "gds_api/test_helpers/email_alert_api"

class SessionsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::AccountApi
  include GdsApi::TestHelpers::EmailAlertApi
  include GovukPersonalisation::TestHelpers::Features

  context "Given a signing in user" do
    should "Log the user in and send them to the account dashboard" do
      given_a_successful_login_attempt
      when_i_return_from_digital_identity
      and_i_see_the_dashboard
    end

    context "With a redirect path" do
      setup do
        @redirect_path = "/email/subscriptions/account/confirm?frequency=immediately&return_to_url=true&topic_id=some-page-with-notifications"
        given_a_successful_login_attempt
      end

      should "Log the user in and send them to the redirect path" do
        assert_this_redirects_me { when_i_return_from_digital_identity }
      end
    end
  end

  def given_a_successful_login_attempt
    @govuk_account_session = "session-id"

    stub_account_api_validates_auth_response(
      govuk_account_session: @govuk_account_session,
      redirect_path: @redirect_path,
    )

    @stub_user_info = stub_account_api_user_info(new_govuk_account_session: @govuk_account_session)
    stub_email_alert_api_authenticate_subscriber_by_govuk_account(@govuk_account_session, "subscriber-id", "email@example.com")
    stub_email_alert_api_has_subscriber_subscriptions("subscriber-id", "example@example.com")
  end

  def when_i_return_from_digital_identity
    visit new_govuk_session_callback_path(code: "code", state: "state")
  end

  def and_i_see_the_dashboard
    assert page.has_content? I18n.t("account.your_account.heading")
    assert_requested @stub_user_info
  end

  def assert_this_redirects_me
    # the /email/... redirect path isn't in this app so ignore a 404
    yield
    assert_current_url account_home_path
  rescue ActionController::RoutingError
    assert_current_url @redirect_path
  end
end
