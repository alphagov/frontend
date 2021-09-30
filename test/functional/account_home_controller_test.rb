require "test_helper"
require "gds_api/test_helpers/account_api"

class AccountHomeControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::AccountApi
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
      should "render the home page" do
        stub_account_api_user_info
        get :show
        assert_response :ok
      end

      should "remind the user to finish setting up the account if `email_verified` is false and `has_unconfirmed_email` is false" do
        stub_account_api_user_info(email_verified: false, has_unconfirmed_email: false)
        get :show
        assert_includes(@response.body, I18n.t("account.confirm.intro.set_up"))
      end

      should "should not show the user a reminder if if `email_verified` s true and `has_unconfirmed_email` false" do
        stub_account_api_user_info(email_verified: true, has_unconfirmed_email: false)
        get :show
        assert_not_includes(@response.body, "#{Plek.find('account-manager')}/account/confirmation/new")
      end

      should "remind the user to finish updating if `email_verified` is true and `has_unconfirmed_email` is true" do
        stub_account_api_user_info(email_verified: true, has_unconfirmed_email: true)
        get :show
        assert_includes(@response.body, I18n.t("account.confirm.intro.update"))
      end
    end
  end
end
