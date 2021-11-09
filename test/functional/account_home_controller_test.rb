require "test_helper"
require "gds_api/test_helpers/account_api"
require "gds_api/test_helpers/email_alert_api"

class AccountHomeControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::AccountApi
  include GdsApi::TestHelpers::EmailAlertApi
  include GovukPersonalisation::TestHelpers::Requests
  include GovukAbTesting::MinitestHelpers

  context "GET '/account/home'" do
    context "when logged out" do
      setup do
        stub_account_api_unauthorized_user_info
        @stub = stub_account_api_get_sign_in_url(
          redirect_path: account_home_path,
        )
      end

      should "redirect the user to the login page" do
        get :show
        assert_response :redirect
        assert_requested @stub
      end

      should "preserve GA tracking params in the redirect" do
        get :show, params: { _ga: "ABC123" }
        assert_equal @response.headers["Location"], "http://auth/provider?_ga=ABC123"
      end
    end

    context "when logged in" do
      setup do
        mock_logged_in_session("session-id")
        stub_account_api_user_info
        stub_email_alert_api_authenticate_subscriber_by_govuk_account(
          "session-id",
          "subscriber-id",
          "example@example.com",
        )
        stub_email_alert_api_has_subscriber_subscriptions(
          "subscriber-id",
          "example@example.com",
        )
      end

      should "render the home page" do
        get :show
        assert_response :ok
      end
    end
  end
end
