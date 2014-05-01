require 'gds_api/helpers'
require 'gds_api/content_api'

class RecordNotFound < StandardError
end

require 'artefact_retriever'

class ApplicationController < ActionController::Base
  protect_from_forgery
  include GdsApi::Helpers
  include Slimmer::Headers

  rescue_from GdsApi::TimedOutException, with: :error_503
  rescue_from GdsApi::EndpointNotFound, with: :error_503
  rescue_from GdsApi::HTTPErrorResponse, with: :error_503
  rescue_from ArtefactRetriever::RecordArchived, with: :error_410
  rescue_from ArtefactRetriever::UnsupportedArtefactFormat, with: :error_404

protected
  def error_404; error 404; end
  def error_410; error 410; end
  def error_503(e); error(503, e); end

  def error(status_code, exception = nil)
    if exception and defined? Airbrake
      env["airbrake.error_id"] = notify_airbrake(exception)
    end
    render status: status_code, text: "#{status_code} error"
  end

  def cacheable_404
    set_expiry(10.minutes)
    error 404
  end

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
    if artefact["format"] == "help_page"
      set_slimmer_artefact_overriding_section(artefact, :section_name => "Help", :section_link => "/help")
    else
      set_slimmer_artefact(artefact)
    end
  end

  def fetch_artefact(slug, edition = nil, snac = nil, location = nil)
    ArtefactRetriever.new(content_api, Rails.logger, statsd).
      fetch_artefact(slug, edition, snac, location)
  end

  def content_api
    @content_api ||= GdsApi::ContentApi.new(
      Plek.current.find("contentapi"),
      content_api_options
    )
  end

  def validate_slug_param(param_name = :slug)
    param_to_use = params[param_name].sub(/(done|help)\//, '')
    if param_to_use.parameterize != param_to_use
      cacheable_404
    end
  rescue StandardError # Triggered by trying to parameterize malformed UTF-8
    cacheable_404
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
