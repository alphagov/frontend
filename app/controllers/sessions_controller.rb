class SessionsController < ApplicationController
  include GovukPersonalisation::ControllerConcern

  before_action :set_no_cache_headers

  def create
    redirect_path = http_referer_path
    redirect_path = nil unless is_valid_redirect_path? redirect_path

    redirect_with_ga GdsApi.account_api.get_sign_in_url(redirect_path: redirect_path)["auth_uri"]
  end

  def callback
    redirect_to Plek.new.website_root and return unless params[:code] && params[:state]

    callback = GdsApi.account_api.validate_auth_response(
      code: params.require(:code),
      state: params.require(:state),
    ).to_h

    set_account_session_header(callback["govuk_account_session"])
    set_cookies_policy(callback["cookie_consent"])

    redirect_with_ga(callback["redirect_path"] || account_home_path, callback["ga_client_id"])
  rescue GdsApi::HTTPUnauthorized
    head :bad_request
  end

  def delete
    logout!
    if params[:continue]
      redirect_with_ga "#{account_manager_url}/sign-out?done=#{params[:continue]}"
    elsif params[:done]
      redirect_with_ga Plek.new.website_root
    else
      redirect_with_ga "#{account_manager_url}/sign-out?continue=1"
    end
  end

protected

  def account_manager_url
    Plek.find("account-manager")
  end

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

  def set_cookies_policy(consent)
    return unless cookies[:cookies_policy]

    cookies_policy = JSON.parse(cookies[:cookies_policy]).symbolize_keys
    cookies[:cookies_policy] = cookies_policy.merge(usage: consent).to_json
  rescue TypeError, JSON::ParserError
    nil
  end
end
