class AccountHomeController < ApplicationController
  include GovukPersonalisation::ControllerConcern
  before_action -> { set_slimmer_headers(template: "gem_layout_account_manager", remove_search: true, show_accounts: "signed-in") }

  def show
    @is_account = true
    @user = GdsApi.account_api.get_user(govuk_account_session: account_session_header).to_h
  rescue GdsApi::HTTPUnauthorized
    logout!
    redirect_with_analytics GdsApi.account_api.get_sign_in_url(redirect_path: account_home_path)["auth_uri"]
  end

private

  helper_method :has_used?

  def has_used?(service_name)
    %w[yes yes_but_must_reauthenticate].include? @user.dig("services", service_name)
  end
end
