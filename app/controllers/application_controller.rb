require 'gds_api/helpers'
require 'gds_api/content_api'

class RecordNotFound < StandardError
end

class RecordArchived < StandardError
end

class UnsupportedArtefactFormat < StandardError
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
  rescue_from UnsupportedArtefactFormat, with: :error_404

  def error(status_code)
    render status: status_code, text: "#{status_code} error"
  end

  protected
    def statsd
      @statsd ||= Statsd.new("localhost").tap do |c|
        c.namespace = ENV['GOVUK_STATSD_PREFIX'].to_s
      end
    end

    def set_expiry(duration = 30.minutes)
      unless Rails.env.development?
        expires_in(duration, :public => true)
      end
    end

    def set_slimmer_artefact_headers(artefact)
      set_slimmer_headers(format: artefact["format"])
      set_slimmer_artefact(artefact)
    end

    def fetch_artefact(snac = nil, location = nil)
      options = { snac: snac, edition: params[:edition] }.delete_if { |k,v| v.blank? }
      unless location.nil?
        options[:latitude]  = location.lat
        options[:longitude] = location.lon
      end
      artefact = content_api.artefact(params[:slug], options)

      unless artefact
        logger.warn("Failed to fetch artefact #{params[:slug]} from Content API. Response code: 404")
        raise RecordNotFound
      end

      unless supported_artefact_formats.include?(artefact['format'])
        raise UnsupportedArtefactFormat
      end
      artefact
    rescue GdsApi::HTTPErrorResponse => e
      if e.code == 410
        raise RecordArchived
      elsif e.code >= 500
        statsd.increment("content_api_error")
      end
      raise
    rescue URI::InvalidURIError
      logger.warn("Failed to fetch artefact from Content API.")
      raise RecordNotFound
    end

    def content_api
      @content_api ||= GdsApi::ContentApi.new(Plek.current.find('contentapi'), CONTENT_API_CREDENTIALS)
    end

    def supported_artefact_formats
      %w{answer business_support completed_transaction guide licence local_transaction place programme transaction travel-advice video}
    end
end
