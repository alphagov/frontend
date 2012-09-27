require 'gds_api/helpers'
require 'gds_api/content_api'

class ApplicationController < ActionController::Base
  protect_from_forgery
  include GdsApi::Helpers
  include Slimmer::Headers

  def error_404; error 404; end
  def error_406; error 406; end
  def error_500; error 500; end
  def error_501; error 501; end
  def error_503; error 503; end

  def error(status_code)
    render status: status_code, text: "#{status_code} error"
  end

  def limit_to_html
    error_406 unless request.format.html?
  end

  protected
  def fetch_publication(params)
    options = {
        edition: params[:edition],
        snac: params[:snac]
    }.reject { |k, v| v.blank? }
    publisher_api.publication_for_slug(params[:slug], options)
  rescue ArgumentError
    logger.error "invalid UTF-8 byte sequence with slug `#{params[:slug]}`"
    return false
  rescue URI::InvalidURIError
    logger.error "Invalid URI formed with slug `#{params[:slug]}`"
    return false
  end
end
