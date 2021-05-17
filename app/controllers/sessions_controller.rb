class SessionsController < ApplicationController
  include AccountConcern

  before_action :set_no_cache_headers

  def create
    level_of_authentication = params[:level_of_authentication]
    unless %w[level0 level1].include? level_of_authentication
      level_of_authentication = nil
    end

    redirect_with_ga GdsApi.account_api.get_sign_in_url(
      redirect_path: params[:redirect_path] || fetch_http_referrer,
      state_id: params[:state_id],
      level_of_authentication: level_of_authentication,
    ).to_h["auth_uri"]
  end

  def callback
    redirect_to Plek.new.website_root and return unless params[:code] && params[:state]

    callback = GdsApi.account_api.validate_auth_response(
      code: params.require(:code),
      state: params.require(:state),
    ).to_h

    set_account_session_header(callback["govuk_account_session"])

    redirect_with_ga(callback["redirect_path"] || account_manager_url, callback["ga_client_id"])
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

  def set_no_cache_headers
    response.headers["Cache-Control"] = "no-store"
  end

  def account_manager_url
    Plek.find("account-manager")
  end

  def fetch_http_referrer
    http_referrer = request.headers["HTTP_REFERER"]

    return nil unless http_referrer&.start_with?(Plek.new.website_root)

    http_referrer.delete_prefix Plek.new.website_root
  end

  def redirect_with_ga(url, ga_client_id = nil)
    ga_client_id ||= params[:_ga]
    if ga_client_id
      url =
        if url.include? "?"
          "#{url}&_ga=#{ga_client_id}"
        else
          "#{url}?_ga=#{ga_client_id}"
        end
    end

    redirect_to url
  end
end
