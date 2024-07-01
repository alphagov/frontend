require "gds_api/test_helpers/account_api"
require "gds_api/test_helpers/email_alert_api"
require "gds_api/test_helpers/content_store"

RSpec.describe "Sessions", type: :feature do
  include GdsApi::TestHelpers::AccountApi
  include GdsApi::TestHelpers::EmailAlertApi
  include GovukPersonalisation::TestHelpers::Features

  before do
    stub_content_store_has_item("/")
  end

  context "Given a signing in user" do
    it "Logs the user in and redirect them to manage their account" do
      given_a_successful_login_attempt
      visit(new_govuk_session_callback_path(code: "code", state: "state"))

      expect(page.current_url).to eq("#{GovukPersonalisation::Urls.one_login_your_services}/")
    end

    context "With a redirect path" do
      before do
        @redirect_path = "/email/subscriptions/account/confirm?frequency=immediately&return_to_url=true&topic_id=some-page-with-notifications"
        given_a_successful_login_attempt
      end

      it "Logs the user in and send them to the redirect path" do
        assert_this_redirects_me { when_i_return_from_digital_identity }
      end
    end
  end

  def given_a_successful_login_attempt
    @govuk_account_session = "session-id"
    stub_account_api_validates_auth_response(govuk_account_session: @govuk_account_session, redirect_path: @redirect_path)
    @stub_user_info = stub_account_api_user_info(new_govuk_account_session: @govuk_account_session)
    stub_email_alert_api_authenticate_subscriber_by_govuk_account(@govuk_account_session, "subscriber-id", "email@example.com")
    stub_email_alert_api_has_subscriber_subscriptions("subscriber-id", "example@example.com")
  end

  def when_i_return_from_digital_identity
    visit(new_govuk_session_callback_path(code: "code", state: "state"))
  end

  def assert_this_redirects_me
    (yield
     assert_current_url(account_home_path))
  rescue ActionController::RoutingError
    assert_current_url(@redirect_path)
  end
end
