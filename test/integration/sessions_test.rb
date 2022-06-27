require_relative "../integration_test_helper"
require "gds_api/test_helpers/account_api"
require "gds_api/test_helpers/email_alert_api"
require "gds_api/test_helpers/content_store"

class SessionsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::AccountApi
  include GdsApi::TestHelpers::EmailAlertApi
  include GovukPersonalisation::TestHelpers::Features

  context "Given a signing in user" do
    should "Log the user in and redirect them to manage their account" do
      given_a_successful_login_attempt
      get new_govuk_session_callback_path(code: "code", state: "state")
      # initial redirect to /account/home which redirects on to the manage page
      assert_response :redirect
      follow_redirect!
      assert response.location = GovukPersonalisation::Urls.manage
    end

    context "With a redirect path" do
      setup do
        @redirect_path = "/email/subscriptions/account/confirm?frequency=immediately&return_to_url=true&topic_id=some-page-with-notifications"
        given_a_successful_login_attempt
      end

      should "Log the user in and send them to the redirect path" do
        ClimateControl.modify GOVUK_PERSONALISATION_MANAGE_URI: "https://account.gov.uk/manage-your-account" do
          assert_this_redirects_me { when_i_return_from_digital_identity }
        end
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

  def assert_this_redirects_me
    # the /email/... redirect path isn't in this app so ignore a 404
    yield
    assert_current_url account_home_path
  rescue ActionController::RoutingError
    assert_current_url @redirect_path
  end
end
