class ApplicationController < ActionController::Base
  include Slimmer::Headers
  include Slimmer::Template
  slimmer_template "gem_layout"

  before_action do
    I18n.locale = I18n.default_locale
  end

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
end
