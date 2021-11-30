class AccountCookiesAndFeedbackController < ApplicationController
  include GovukPersonalisation::ControllerConcern
  before_action -> { set_slimmer_headers(template: "gem_layout_account_manager_manage_your_account_active", remove_search: true, show_accounts: "signed-in") }

  def show
    result = do_or_logout do
      GdsApi.account_api.get_attributes(
        attributes: %w[cookie_consent feedback_consent],
        govuk_account_session: account_session_header,
      )
    end

    redirect_to_cookies_and_feedback and return unless logged_in?

    @cookie_consent = result.dig("values", "cookie_consent")
    @feedback_consent = result.dig("values", "feedback_consent")
    @success = params[:success].present?
  end

  def update
    @cookie_consent = params[:cookie_consent] == "yes"
    @feedback_consent = params[:feedback_consent] == "yes"

    do_or_logout do
      GdsApi.account_api.set_attributes(
        attributes: {
          cookie_consent: @cookie_consent,
          feedback_consent: @feedback_consent,
        },
        govuk_account_session: account_session_header,
      )
    end

    if logged_in?
      redirect_to account_cookies_and_feedback_path(
        cookie_consent: @cookie_consent ? "accept" : "reject",
        success: true,
      )
    else
      redirect_to_cookies_and_feedback
    end
  end

private

  def do_or_logout
    return unless account_session_header

    result = yield
    set_account_session_header(result["govuk_account_session"])
    result
  rescue GdsApi::HTTPUnauthorized
    logout!
  end

  def redirect_to_cookies_and_feedback
    redirect_with_analytics GdsApi.account_api.get_sign_in_url(redirect_path: account_cookies_and_feedback_path)["auth_uri"]
  end
end
