require 'gds_api/helpers'
require 'gds_api/content_api'

class RecordNotFound < StandardError
end

class RecordArchived < StandardError
end

class ApplicationController < ActionController::Base
  protect_from_forgery
  include GdsApi::Helpers
  include Slimmer::Headers

  def error_404; error 404; end
  def error_406; error 406; end
  def error_410; error 410; end
  def error_500; error 500; end
  def error_501; error 501; end
  def error_503; error 503; end

  rescue_from GdsApi::TimedOutException, with: :error_503
  rescue_from GdsApi::EndpointNotFound, with: :error_503
  rescue_from GdsApi::HTTPErrorResponse, with: :error_503
  rescue_from RecordArchived, with: :error_410

  def error(status_code)
    render status: status_code, text: "#{status_code} error"
  end

  def limit_to_html
    error_406 unless request.format.html?
  end

  protected
    def statsd
      @statsd ||= Statsd.new("localhost").tap do |c|
        c.namespace = "govuk.app.frontend"
      end
    end

    def fetch_artefact(snac = nil)
      options = { snac: snac, edition: params[:edition] }.delete_if { |k,v| v.blank? }
      artefact = content_api.artefact(params[:slug], options)

      unless artefact
        logger.warn("Failed to fetch artefact #{params[:slug]} from Content API. Response code: 404")
        raise RecordNotFound
      end
      artefact
    rescue GdsApi::HTTPErrorResponse => e
      if e.code == 410
        raise RecordArchived
      else
        raise
      end
    rescue URI::InvalidURIError
      logger.warn("Failed to fetch artefact from Content API.")
      raise RecordNotFound
    end

    def content_api
      @content_api ||= GdsApi::ContentApi.new(Plek.current.environment, CONTENT_API_CREDENTIALS)
    end
end
