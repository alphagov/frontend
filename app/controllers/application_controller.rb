require 'gds_api/helpers'
require 'gds_api/content_api'

class RecordNotFound < StandardError
end

class RecordArchived < StandardError
end

class UnsupportedArtefactFormat < StandardError
end

require 'artefact_retriever'

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

    def set_slimmer_artefact_headers(artefact, slimmer_headers = {})
      slimmer_headers[:format] ||= artefact["format"]
      set_slimmer_headers(slimmer_headers)
      set_slimmer_artefact(artefact)
    end

    def fetch_artefact(slug, edition = nil, snac = nil, location = nil)
      ArtefactRetriever.new(content_api, Rails.logger, statsd).fetch_artefact(slug, edition, snac, location)
    end

    def content_api
      @content_api ||= GdsApi::ContentApi.new(
        Plek.current.find("contentapi"),
        content_api_options
      )
    end

    def validate_slug_param(param_name = :slug)
      if params[param_name].parameterize != params[param_name]
        error 404
      end
    rescue ArgumentError # Triggered by malformed UTF-8
      error 404
    end

  private
    def content_api_options
      options = CONTENT_API_CREDENTIALS
      unless request.format == :atom
        options = options.merge(web_urls_relative_to: Plek.current.website_root)
      end
      options
    end
end
