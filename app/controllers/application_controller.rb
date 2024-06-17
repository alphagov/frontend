class ApplicationController < ActionController::Base
  include Slimmer::Headers
  include Slimmer::Template
  slimmer_template "gem_layout"

  before_action :force_html_format_before_action

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

  if ENV["BASIC_AUTH_USERNAME"]
    http_basic_authenticate_with(
      name: ENV.fetch("BASIC_AUTH_USERNAME"),
      password: ENV.fetch("BASIC_AUTH_PASSWORD"),
    )
  end

  class << self
  protected

    def force_html_format(only: nil, except: nil)
      only_copy = only && only.collect(&:to_sym).freeze
      except_copy = except && except.collect(&:to_sym).freeze
      define_method(:force_html_format_only) { only_copy }
      define_method(:force_html_format_except) { except_copy }
    end
  end

protected

  helper_method :content_item, :content_item_hash, :publication

  def force_html_format_only
    [] # do not force html for any actions by default
  end

  def force_html_format_except
    nil # do not exclude any actions by default
  end

  def force_html_format_before_action
    request.format = :html if force_html_format?
  end

  def force_html_format?
    action_name_sym = action_name.to_sym
    (
      force_html_format_only.nil? ||
      force_html_format_only.include?(action_name_sym)
    ) &&
      (
        force_html_format_except.nil? ||
        !force_html_format_except.include?(action_name_sym)
      )
  end

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

  # TODO: Remove these nil methods by moving logic down from application.html.erb
  # to a content item specific view.
  def publication
    nil
  end

  def content_item
    nil
  end

  def content_item_hash
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
