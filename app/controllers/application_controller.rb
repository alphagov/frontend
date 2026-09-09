class ApplicationController < ActionController::Base
  include DraftHelper

  # Short-term workaround for WHIT-3992-style failures: a draft document can
  # contain several draft images, and each one independently triggers its
  # own Asset Manager/Signon authentication handshake when there's no
  # existing Asset Manager session. Because those handshakes can complete
  # out of order, they invalidate each other's session state and the
  # images fail to load. To avoid this, we make sure a single Asset
  # Manager session has already been established (see
  # AssetManagerPreflightController) before rendering any draft page that
  # might contain draft images.
  ASSET_MANAGER_PREFLIGHT_COOKIE = :asset_manager_session_invoked
  ASSET_MANAGER_PREFLIGHT_TTL = 30.minutes

  # Query params that are either meaningless to forward (Rails routing
  # internals) or that we set ourselves and must never let an incoming
  # request's own query string collide with/override - most importantly
  # return_to, which AssetManagerPreflightController trusts to build a
  # same-host redirect. See #redirect_to_asset_manager_preflight_if_required
  # and AssetManagerPreflightController#forwarded_params.
  ASSET_MANAGER_PREFLIGHT_RESERVED_PARAMS = %w[return_to controller action].freeze

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
  # AssetManagerPreflightController, unless we already have a cookie
  # recording that we've recently warmed up an Asset Manager session in
  # this browser. See the comment above ASSET_MANAGER_PREFLIGHT_COOKIE.
  #
  # Any query params on the original request (e.g. the Whitehall/Publishing
  # API access-limiting bypass token, or anything else we haven't thought
  # of) are forwarded on to the preflight page, which in turn forwards them
  # on to the placeholder asset request - see AssetManagerPreflightController.
  # return_to is ours alone: we strip it (and the Rails routing params) from
  # whatever the request already had before setting our own, so a
  # same-named incoming param can never collide with or override it.
  def redirect_to_asset_manager_preflight_if_required
    return unless request.get?
    return unless draft_host?
    return if cookies[ASSET_MANAGER_PREFLIGHT_COOKIE].present?

    redirect_params = request.query_parameters.except(*ASSET_MANAGER_PREFLIGHT_RESERVED_PARAMS)
    redirect_params["return_to"] = request.original_fullpath

    redirect_to asset_manager_preflight_path(redirect_params)
  end
end
