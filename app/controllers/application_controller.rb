require 'gds_api/helpers'
require 'gds_api/content_api'
require 'artefact_retriever'

class ApplicationController < ActionController::Base
  protect_from_forgery
  include GdsApi::Helpers
  include Slimmer::Headers
  include Slimmer::Template
  include Slimmer::GovukComponents

  rescue_from GdsApi::TimedOutException, with: :error_503
  rescue_from GdsApi::EndpointNotFound, with: :error_503
  rescue_from GdsApi::HTTPErrorResponse, with: :error_503
  rescue_from GdsApi::HTTPGone, with: :error_410
  rescue_from GdsApi::HTTPNotFound, with: :cacheable_404
  rescue_from GdsApi::InvalidUrl, with: :cacheable_404
  rescue_from ArtefactRetriever::RecordArchived, with: :error_410
  rescue_from ArtefactRetriever::UnsupportedArtefactFormat, with: :error_404
  rescue_from ArtefactRetriever::RecordNotFound, with: :cacheable_404
  rescue_from RecordNotFound, with: :cacheable_404

  slimmer_template 'wrapper'

  attr_accessor :navigation_helpers

  helper_method :breadcrumbs

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

  def set_expiry(duration = 30.minutes)
    unless Rails.env.development?
      expires_in(duration, public: true)
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

  rescue GdsApi::HTTPNotFound, GdsApi::HTTPGone
    # We can't always be sure that the page has a content-item, since this
    # application also runs as `private-frontend` to preview unpublished content,
    # which doesn't exist in the content-store yet. However, when running in
    # "normal" mode there should be a content item for all pages rendered.
    @navigation_helpers, @content_item, @meta_section = nil
  end

  def set_content_item
    @publication = ContentItemPresenter.new(content_item)
    set_language_from_publication
  end

  def set_publication
    @publication = PublicationPresenter.new(artefact)
    set_language_from_publication
  end

  def set_language_from_publication
    I18n.locale = if @publication.locale && I18n.available_locales.map(&:to_s).include?(@publication.locale)
                    @publication.locale
                  else
                    I18n.default_locale
                  end
  end

  def content_item
    @_content_item ||= Services.content_store.content_item("/#{params[:slug]}")
  end

  def artefact
    @_artefact ||= ArtefactRetrieverFactory.artefact_retriever.fetch_artefact(
      params[:slug],
      params[:edition]
    )
  end

  def breadcrumbs
    return {} if navigation_helpers.nil?

    if present_new_navigation?
      navigation_helpers.taxon_breadcrumbs
    else
      navigation_helpers.breadcrumbs
    end
  end

  def present_new_navigation?
    if defined?(should_present_new_navigation_view?)
      should_present_new_navigation_view?
    end
  end
  helper_method :present_new_navigation?
end
