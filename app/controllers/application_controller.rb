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
    def fetch_artefact(snac = nil)
      options = { snac: snac, edition: params[:edition] }.delete_if { |k,v| v.blank? }
      artefact = content_api.artefact(params[:slug], options)

      unless artefact
        logger.warn("Failed to fetch artefact #{params[:slug]} from Content API. Response code: 404")
        raise RecordNotFound
      end
      artefact
    rescue URI::InvalidURIError
      logger.warn("Failed to fetch artefact from Content API.")
      raise RecordNotFound
    end
end
