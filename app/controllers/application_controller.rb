class ApplicationController < ActionController::Base
  include DraftHelper

  before_action { I18n.locale = I18n.default_locale }
  before_action :allow_only_html_requests
  before_action :redirect_to_asset_manager_preflight_if_required, if: -> { request.format.html? }

  rescue_from GdsApi::TimedOutException, with: :error_503
  rescue_from GdsApi::EndpointNotFound, with: :error_503
  rescue_from GdsApi::HTTPErrorResponse, with: :error_503
  rescue_from GdsApi::HTTPGone, with: :error_410
  rescue_from GdsApi::HTTPNotFound, with: :cacheable_404
  rescue_from GdsApi::InvalidUrl, with: :cacheable_404
  rescue_from GdsApi::HTTPForbidden, with: :error_403
  rescue_from RecordNotFound, with: :cacheable_404

  # Because this code contains an if statement evaluated on Rails load and is just
  # for a standard well-tested Rails method, we can exclude it from needing to be
  # covered in tests. Do not change it without very good reason!
  # :nocov:
  if ENV["BASIC_AUTH_USERNAME"]
    http_basic_authenticate_with(
      name: ENV.fetch("BASIC_AUTH_USERNAME"),
      password: ENV.fetch("BASIC_AUTH_PASSWORD"),
    )
  end
  # :nocov:

protected

  helper_method :content_item

  def error_403
    error :forbidden
  end

  def error_410
    error :gone
  end

  def error_503(exception)
    error(:service_unavailable, exception)
  end

  def error(status_code, exception = nil)
    if exception
      GovukError.notify(exception)
    end

    head(status_code)
  end

  def cacheable_404
    set_expiry(10.minutes)
    error :not_found
  end

  def set_expiry(duration = 30.minutes)
    unless Rails.env.development?
      expires_in(duration, public: true)
    end
  end

  def content_item
    nil
  end

private

  def allow_only_html_requests
    if params[:format] && params[:format] != "html"
      head :not_acceptable
    end
  end

  def default_url_options
    {}.merge(token)
      .merge(cache)
  end

  def token
    params[:token] ? { token: params[:token] } : {}
  end

  def cache
    params[:cache] ? { cache: params[:cache] } : {}
  end

  def set_no_cache_headers
    response.headers["Cache-Control"] = "no-store"
  end

  # Redirects the current (draft-host, GET, HTML) request to
  # AssetManagerPreflightController, unless the session already
  # records that we've recently warmed up an Asset Manager session.
  def redirect_to_asset_manager_preflight_if_required
    return unless request.get?
    return unless draft_host?
    return if asset_manager_session_warm?

    redirect_params = request.query_parameters.except(*AssetManagerPreflightController::ASSET_MANAGER_PREFLIGHT_RESERVED_PARAMS)
    return_to = request.path

    return_to += "?#{redirect_params.to_query}" if redirect_params.present?

    redirect_params["return_to"] = return_to

    redirect_to asset_manager_preflight_path(redirect_params)
  end

  # The session stores an epoch timestamp so we can tell how long
  # ago the Asset Manager session was warmed up and treat it as
  # stale after ASSET_MANAGER_PREFLIGHT_TTL.
  def asset_manager_session_warm?
    set_up_at = session[AssetManagerPreflightController::ASSET_MANAGER_SESSION_KEY]
    set_up_at.present? && set_up_at > AssetManagerPreflightController::ASSET_MANAGER_PREFLIGHT_TTL.ago.to_i
  end
end
