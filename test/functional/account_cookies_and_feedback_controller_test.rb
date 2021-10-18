require "test_helper"
require "gds_api/test_helpers/account_api"

class AccountCookiesAndFeedbackControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::AccountApi
  include GovukPersonalisation::TestHelpers::Requests
  include GovukAbTesting::MinitestHelpers

  context "GET '/account/cookies-and-feedback'" do
    context "when logged out" do
      setup do
        stub_account_api_unauthorized_has_attributes(attributes: %w[cookie_consent feedback_consent])
        @stub = stub_account_api_get_sign_in_url(
          redirect_path: account_cookies_and_feedback_path,
        )
      end

      should "redirect the user to the login page" do
        get :show
        assert_response :redirect
        assert_requested @stub
      end
    end
  end
end
