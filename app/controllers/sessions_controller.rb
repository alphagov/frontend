class SessionsController < ApplicationController
  include GovukPersonalisation::ControllerConcern

  before_action :set_no_cache_headers

  def create
    redirect_path = http_referer_path
    redirect_path = nil unless is_valid_redirect_path? redirect_path

    redirect_with_analytics GdsApi.account_api.get_sign_in_url(redirect_path:)["auth_uri"]
  end

  def callback
    redirect_to Plek.new.website_root, allow_other_host: true and return unless params[:code] && params[:state]

    callback = GdsApi.account_api.validate_auth_response(
      code: params.require(:code),
      state: params.require(:state),
    ).to_h

    do_login(
      redirect_path: callback["redirect_path"],
      cookie_consent: params[:cookie_consent],
      govuk_account_session: callback["govuk_account_session"],
    )
  rescue GdsApi::HTTPUnauthorized
    head :bad_request
  end

  def delete
    logout!
    redirect_with_analytics GdsApi.account_api.get_end_session_url(govuk_account_session: account_session_header)["end_session_uri"]
  end

protected

  def http_referer_path
    @http_referer_path ||=
      begin
        http_referer = request.headers["HTTP_REFERER"]

        if http_referer&.start_with?(Plek.new.website_root)
          http_referer.delete_prefix Plek.new.website_root
        end
      end
  end

  def is_valid_redirect_path?(value)
    return true if value.blank?
    return false if value.starts_with? "//"
    return true if value.starts_with? "/"
    return true if value.starts_with?("http://") && Rails.env.development?

    false
  end

  def do_login(redirect_path:, cookie_consent:, govuk_account_session:)
    set_account_session_header(govuk_account_session)
    redirect_to GovukPersonalisation::Redirect.build_url(
      redirect_path.presence || account_home_path,
      {
        _ga: params[:_ga].presence,
        cookie_consent:,
      }.compact,
    )
  end
end
