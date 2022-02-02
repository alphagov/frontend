require "integration_test_helper"
require "gds_api/test_helpers/account_api"
require "gds_api/test_helpers/email_alert_api"

class SessionsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::AccountApi
  include GdsApi::TestHelpers::EmailAlertApi
  include GovukPersonalisation::TestHelpers::Features

  context "Given a new user" do
    should "Prompt for cookie and feedback consent, and then send them to the account dashboard" do
      given_a_successful_login_attempt(cookie_consent: nil, feedback_consent: nil)

      when_i_return_from_digital_identity
      then_i_see_the_first_time_form

      when_i_consent_to_cookies
      when_i_consent_to_feedback
      assert_this_redirects_me { and_i_click_continue }
      and_my_consents_have_been_saved
      and_i_see_the_dashboard
    end

    context "With a redirect path" do
      setup do
        @redirect_path = "/email/subscriptions/account/confirm?frequency=immediately&return_to_url=true&topic_id=some-page-with-notifications"
        given_a_successful_login_attempt(cookie_consent: nil, feedback_consent: nil)
      end

      should "Prompt for cookie and feedback consent, and then send them to the redirect path" do
        when_i_return_from_digital_identity
        then_i_see_the_first_time_form

        when_i_consent_to_cookies
        when_i_consent_to_feedback
        assert_this_redirects_me { and_i_click_continue }
        and_my_consents_have_been_saved
      end

      should "Enforce that cookie consent is explicitly given or rejected" do
        when_i_return_from_digital_identity
        then_i_see_the_first_time_form

        when_i_consent_to_feedback
        and_i_click_continue
        then_i_see_the_first_time_form
        and_i_see_an_error_about_invalid_cookie_consent

        when_i_consent_to_cookies
        assert_this_redirects_me { and_i_click_continue }
        and_my_consents_have_been_saved
      end

      should "Enforce that feedback consent is explicitly given or rejected" do
        when_i_return_from_digital_identity
        then_i_see_the_first_time_form

        when_i_consent_to_cookies
        and_i_click_continue
        then_i_see_the_first_time_form
        and_i_see_an_error_about_invalid_feedback_consent

        when_i_consent_to_feedback
        assert_this_redirects_me { and_i_click_continue }
        and_my_consents_have_been_saved
      end
    end
  end

  context "Given a returning user" do
    should "Log the user in and send them to the account dashboard" do
      given_a_successful_login_attempt(cookie_consent: true, feedback_consent: false)
      assert_this_redirects_me { when_i_return_from_digital_identity }
      and_i_see_the_dashboard
    end

    context "With a redirect path" do
      setup do
        @redirect_path = "/email/subscriptions/account/confirm?frequency=immediately&return_to_url=true&topic_id=some-page-with-notifications"
        given_a_successful_login_attempt(cookie_consent: true, feedback_consent: false)
      end

      should "Log the user in and send them to the redirect path" do
        assert_this_redirects_me { when_i_return_from_digital_identity }
      end
    end
  end

  def given_a_successful_login_attempt(cookie_consent:, feedback_consent:)
    @govuk_account_session = "new-session-id"

    stub_account_api_validates_auth_response(
      govuk_account_session: @govuk_account_session,
      redirect_path: @redirect_path,
      cookie_consent: cookie_consent,
      feedback_consent: feedback_consent,
    )

    if cookie_consent.nil? || feedback_consent.nil?
      @stub_set_consents = stub_account_api_set_attributes(
        attributes: {
          cookie_consent: true,
          feedback_consent: true,
        },
        govuk_account_session: @govuk_account_session,
        new_govuk_account_session: @govuk_account_session,
      )

      # needed because we can't make capybara handle our special
      # response header (ideally we'd have some code run between
      # visiting the callback endpoint and making the request to the
      # form, to pluck out the response header and fill in the request
      # header)
      mock_logged_in_session "!#{@govuk_account_session}"
    end

    @stub_user_info = stub_account_api_user_info
    stub_email_alert_api_authenticate_subscriber_by_govuk_account("!#{@govuk_account_session}", "subscriber-id", "email@example.com")
    stub_email_alert_api_authenticate_subscriber_by_govuk_account(@govuk_account_session, "subscriber-id", "email@example.com")
    stub_email_alert_api_has_subscriber_subscriptions("subscriber-id", "example@example.com")
  end

  def when_i_return_from_digital_identity
    visit new_govuk_session_callback_path(code: "code", state: "state")
  end

  def when_i_consent_to_cookies
    within "#cookie_consent" do
      choose "Yes"
    end
  end

  def when_i_consent_to_feedback
    within "#feedback_consent" do
      choose "Yes"
    end
  end

  def and_i_click_continue
    click_on "Continue"
  end

  def then_i_see_the_first_time_form
    assert page.has_content? "use cookies to collect anonymised analytics"
  end

  def and_i_see_an_error_about_invalid_cookie_consent
    assert page.has_content? I18n.t("sessions.first_time.cookie_consent.field.invalid")
  end

  def and_i_see_an_error_about_invalid_feedback_consent
    assert page.has_content? I18n.t("sessions.first_time.feedback_consent.field.invalid")
  end

  def and_my_consents_have_been_saved
    assert_requested @stub_set_consents
  end

  def and_i_see_the_dashboard
    assert page.has_content? I18n.t("account.your_account.heading")
    assert_requested @stub_user_info
  end

  def assert_this_redirects_me
    # the /email/... redirect path isn't in this app so ignore a 404
    yield
    assert_current_url "#{account_home_path}?cookie_consent=accept"
  rescue ActionController::RoutingError
    assert_current_url "#{@redirect_path}&cookie_consent=accept"
  end
end
