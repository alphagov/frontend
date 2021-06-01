class SavePagesController < ApplicationController
  include AccountConcern

  before_action :set_no_cache_headers
  before_action { head :not_found unless feature_flag_enabled? }
  before_action { head :unprocessable_entity if params[:page_path].blank? }

  def create
    GdsApi.account_api.save_page(
      page_path: page_path,
      govuk_account_session: account_session_header,
    )
    redirect_to page_path + "?personalisation=page_saved"
  rescue GdsApi::HTTPUnauthorized
    authenticate(save_page_path(page_path: page_path))
  rescue GdsApi::HTTPUnprocessableEntity
    head :unprocessable_entity
  end

  def destroy
    GdsApi.account_api.delete_saved_page(
      page_path: page_path,
      govuk_account_session: account_session_header,
    )

    redirect_to page_path + "?personalisation=page_removed"
  rescue GdsApi::HTTPUnauthorized
    authenticate(remove_saved_page_path(page_path: page_path))
  rescue GdsApi::HTTPNotFound
    redirect_to page_path + "?personalisation=page_removed"
  end

private

  def page_path
    @page_path ||= Addressable::URI.parse(params[:page_path]).path
  end

  def authenticate(redirect_path)
    logout!

    redirect_with_ga GdsApi.account_api.get_sign_in_url(
      redirect_path: redirect_path,
      level_of_authentication: "level0",
    ).to_h["auth_uri"]
  end

  def feature_flag_enabled?
    ENV["FEATURE_FLAG_SAVE_A_PAGE"] == "enabled"
  end
end
