require 'gds_api/helpers'
require 'gds_api/content_api'

class RecordNotFound < StandardError
end

require 'artefact_retriever'

class ApplicationController < ActionController::Base
  protect_from_forgery
  include GdsApi::Helpers
  include Slimmer::Headers
  include Slimmer::Template
  include Slimmer::SharedTemplates

  rescue_from GdsApi::TimedOutException, with: :error_503
  rescue_from GdsApi::EndpointNotFound, with: :error_503
  rescue_from GdsApi::HTTPErrorResponse, with: :error_503
  rescue_from ArtefactRetriever::RecordArchived, with: :error_410
  rescue_from ArtefactRetriever::UnsupportedArtefactFormat, with: :error_404

  slimmer_template 'wrapper'

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

  def set_content_security_policy
    return unless Frontend::Application.config.enable_csp

    asset_hosts = "#{Plek.new.find('static')} #{Plek.new.asset_root}"

    # Our Content-Security-Policy directives use 'unsafe-inline' for scripts and
    # styles because current browsers (Chrome 39 and Firefox 35) only support the
    # CSP 1 spec, which does not provide support for whitelisting assets with
    # hash digests.

    default_src = "default-src #{asset_hosts}"
    script_src = "script-src #{asset_hosts} *.google-analytics.com 'unsafe-inline'"
    style_src = "style-src #{asset_hosts} 'unsafe-inline'"
    img_src = "img-src #{asset_hosts} *.google-analytics.com"
    font_src = "font-src #{asset_hosts} data:"
    report_uri = "report-uri #{Frontend.govuk_website_root}/e"

    csp_header = "#{default_src}; #{script_src}; #{style_src}; #{img_src}; #{font_src}; #{report_uri}"

    headers['Content-Security-Policy-Report-Only'] = csp_header
  end

  def set_expiry(duration = 30.minutes)
    unless Rails.env.development?
      expires_in(duration, public: true)
    end
  end

  def set_slimmer_artefact_headers(artefact, slimmer_headers = {})
    set_slimmer_headers(slimmer_headers)
    if artefact["format"] == "help_page"
      set_slimmer_artefact_overriding_section(artefact, section_name: "Help", section_link: "/help")
    else
      set_slimmer_artefact(artefact)
    end
  end

  def setup_content_item_and_navigation_helpers(base_path)
    @content_item = content_store.content_item(base_path).to_hash
    # Remove the organisations from the content item - this will prevent the
    # govuk:analytics:organisations meta tag from being generated until there is
    # a better way of doing this. This is so we don't add the tag to pages that
    # didn't have it before, thereby swamping analytics.
    if @content_item["links"]
      @content_item["links"].delete("organisations")
    end

    @navigation_helpers = GovukNavigationHelpers::NavigationHelper.new(@content_item)
    section_name = @content_item.dig("links", "parent", 0, "links", "parent", 0, "title")
    if section_name
      @meta_section = section_name.downcase
    end
  end

  def fetch_artefact(slug, edition = nil, snac = nil)
    ArtefactRetriever.new(content_api, Rails.logger, statsd).
      fetch_artefact(slug, edition, snac)
  end

  def content_api
    @content_api ||= GdsApi::ContentApi.new(
      Plek.new.find("contentapi"),
      content_api_options
    )
  end

  def content_store
    @content_store ||= GdsApi::ContentStore.new(
      Plek.new.find("content-store")
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
      options = options.merge(web_urls_relative_to: Frontend.govuk_website_root)
    end
    options
  end
end
