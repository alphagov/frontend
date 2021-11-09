class AccountHomeController < ApplicationController
  include GovukPersonalisation::ControllerConcern
  before_action -> { set_slimmer_headers(template: "gem_layout_account_manager", remove_search: true, show_accounts: "signed-in") }

  def show
    @is_account = true
    @user = GdsApi.account_api.get_user(govuk_account_session: account_session_header).to_h
    @has_email_subscriptions = has_email_subscriptions?
  rescue GdsApi::HTTPUnauthorized
    logout!
    redirect_with_analytics GdsApi.account_api.get_sign_in_url(redirect_path: account_home_path)["auth_uri"]
  end

private

  helper_method :show_confirmation_reminder?

  def show_confirmation_reminder?
    return false unless @user

    !@user["email_verified"] || @user["has_unconfirmed_email"]
  end

  helper_method :confirmation_banner_prompt_type

  def confirmation_banner_prompt_type
    return "update" if confirmed_user_changed_email?

    "set_up"
  end

  helper_method :has_used?

  def has_used?(service_name)
    %w[yes yes_but_must_reauthenticate].include? @user.dig("services", service_name)
  end

  def confirmed_user_changed_email?
    return false unless @user

    @user["email_verified"] && @user["has_unconfirmed_email"]
  end

  def has_email_subscriptions?
    subscriber = GdsApi.email_alert_api.authenticate_subscriber_by_govuk_account(
      govuk_account_session: @account_session_header,
    ).to_h.fetch("subscriber")

    subscriptions = GdsApi.email_alert_api.get_subscriptions(id: subscriber.fetch("id")).to_h.fetch("subscriptions", [])
    !subscriptions.empty?
  rescue GdsApi::HTTPNotFound
    false
  end
end
