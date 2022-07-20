require "integration_test_helper"

class AccountHomeTest < ActionDispatch::IntegrationTest
  context "/account/home" do
    should "redirect users to the manage your account page" do
      ClimateControl.modify GOVUK_PERSONALISATION_YOUR_ACCOUNT_URI: "https://account.gov.uk/" do
        get account_home_path
        assert_response :redirect
        assert response.location = GovukPersonalisation::Urls.your_account
      end
    end

    context "when there are cookie consent and _ga url parameters" do
      should "preserve them through the redirect" do
        ClimateControl.modify GOVUK_PERSONALISATION_YOUR_ACCOUNT_URI: "https://account.gov.uk/" do
          get account_home_path(cookie_consent: true, _ga: "abc123")
          assert_response :redirect
          assert response.location.include? "cookie_consent=true"
          assert response.location.include? "_ga=abc123"
        end
      end
    end
  end
end
