class SavePagesController < ApplicationController
  include AccountConcern

  before_action :set_no_cache_headers
  before_action { head :not_found unless feature_flag_enabled? }
  before_action :authenticate

  def create
    GdsApi.account_api.save_page(
      page_path: ensure_is_path(params[:page_path]),
      govuk_account_session: account_session_header,
    )
    redirect_to ensure_is_path(params[:page_path]) + "?personalisation=page_saved"
  rescue GdsApi::HTTPUnauthorized
    @account_session_header = nil
    authenticate
  rescue GdsApi::HTTPUnprocessableEntity
    redirect_to ensure_is_path(params[:page_path]) + "?personalisation=page_not_saved"
  end

  def destroy
    GdsApi.account_api.delete_saved_page(
      page_path: ensure_is_path(params[:page_path]),
      govuk_account_session: account_session_header,
    )

    redirect_to ensure_is_path(params[:page_path]) + "?personalisation=page_removed"
  end

private

  def authenticate
    return if !feature_flag_enabled? || logged_in?

    redirect_with_ga GdsApi.account_api.get_sign_in_url(
      redirect_path: sign_in_redirect_path,
      level_of_authentication: "level0",
    ).to_h["auth_uri"]
  end

  def sign_in_redirect_path
    if request.env["PATH_INFO"] == save_page_path
      save_page_path(page_path: params[:page_path])
    elsif request.env["PATH_INFO"] == remove_saved_page_path
      remove_saved_page_path(page_path: params[:page_path])
    end
  end

  def feature_flag_enabled?
    ENV["FEATURE_FLAG_SAVE_A_PAGE"] == "enabled"
  end

  def ensure_is_path(path)
    Addressable::URI.parse(path).path
  end
end
