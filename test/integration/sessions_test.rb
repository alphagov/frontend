require "integration_test_helper"
require "gds_api/test_helpers/account_api"

class SessionsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::AccountApi
  include GovukPersonalisation::TestHelpers::Features

  context "HTTP Referer" do
    should "add a redirect_path param to /sign-in/redirect from the HTTP Referer header" do
      stub = stub_account_api_get_sign_in_url(redirect_path: "/transition-check/results?c[]=import-wombats&c[]=practice-wizardry")

      get "/sign-in/redirect", headers: { "Referer" => "#{Plek.new.website_root}/transition-check/results?c[]=import-wombats&c[]=practice-wizardry" }

      assert_response :redirect
      assert_requested stub
    end

    should "not allow protocol-relative redirects" do
      stub = stub_account_api_get_sign_in_url
      stub_evil = stub_account_api_get_sign_in_url(redirect_path: "//evil")

      get "/sign-in/redirect", headers: { "Referer" => "//evil" }

      assert_response :redirect
      assert_requested stub
      assert_not_requested stub_evil
    end

    should "not allow absolute redirects" do
      stub = stub_account_api_get_sign_in_url
      stub_evil = stub_account_api_get_sign_in_url(redirect_path: "http://www.evil.com")

      get "/sign-in/redirect", headers: { "Referer" => "http://www.evil.com" }

      assert_response :redirect
      assert_requested stub
      assert_not_requested stub_evil
    end
  end

  context "First-time consent form" do
    setup do
      @govuk_account_session = "new-session-id"
      @redirect_path = "/email/subscriptions/account/confirm?frequency=immediately&return_to_url=true&topic_id=some-page-with-notifications"

      stub_account_api_validates_auth_response(
        govuk_account_session: @govuk_account_session,
        redirect_path: @redirect_path,
        cookie_consent: nil,
        feedback_consent: nil,
      )

      stub_account_api_set_attributes(
        attributes: {
          cookie_consent: true,
          feedback_consent: true,
        },
        govuk_account_session: @govuk_account_session,
        new_govuk_account_session: @govuk_account_session,
      )
    end

    should "send the user back to the redirect path" do
      mock_logged_in_session "!#{@govuk_account_session}"

      visit new_govuk_session_callback_path(code: "code", state: "state")

      assert page.has_content? "use cookies to collect anonymised analytics"

      within "#cookie_consent" do
        choose "Yes"
      end

      within "#feedback_consent" do
        choose "Yes"
      end

      # the redirect path isn't in this app so ignore that (and fail if we're not redirected)
      begin
        click_on "Continue"
        assert false
      rescue ActionController::RoutingError
        assert_current_url "#{@redirect_path}&_ga=&cookie_consent=accept"
      end
    end
  end
end
