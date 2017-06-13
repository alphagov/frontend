require 'gds_api/helpers'

class ApplicationController < ActionController::Base
  protect_from_forgery
  include GdsApi::Helpers
  include Slimmer::Headers
  include Slimmer::Template
  include Slimmer::GovukComponents
  include BenchmarkingContactDvlaABTestable

  rescue_from GdsApi::TimedOutException, with: :error_503
  rescue_from GdsApi::EndpointNotFound, with: :error_503
  rescue_from GdsApi::HTTPErrorResponse, with: :error_503
  rescue_from GdsApi::HTTPGone, with: :error_410
  rescue_from GdsApi::HTTPNotFound, with: :cacheable_404
  rescue_from GdsApi::InvalidUrl, with: :cacheable_404
  rescue_from RecordNotFound, with: :cacheable_404

  slimmer_template 'wrapper'

  attr_accessor :navigation_helpers

  helper_method(
    :breadcrumbs,
    :navigation_helpers,
    :should_show_benchmarking_variant?,
    :should_show_benchmarking_lab_variant?
  )

protected

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

  def setup_content_item(base_path)
    @content_item = content_store.content_item(base_path).to_hash
    # Remove the organisations from the content item - this will prevent the
    # govuk:analytics:organisations meta tag from being generated until there is
    # a better way of doing this. This is so we don't add the tag to pages that
    # didn't have it before, thereby swamping analytics.
    if @content_item["links"]
      @content_item["links"].delete("organisations")
    end
  rescue GdsApi::HTTPNotFound, GdsApi::HTTPGone
    @content_item = nil
  end

  def setup_content_item_and_navigation_helpers(base_path)
    setup_content_item(base_path)

    if @content_item
      @navigation_helpers = GovukNavigationHelpers::NavigationHelper.new(@content_item)
      section_name = @content_item.dig("links", "parent", 0, "links", "parent", 0, "title")
      if section_name
        @meta_section = section_name.downcase
      end
    else
      @navigation_helpers, @meta_section = nil
    end
  end

  def set_content_item(presenter = ContentItemPresenter)
    @publication = presenter.new(content_item)
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

  def breadcrumbs
    return {} if navigation_helpers.nil?

    if present_new_navigation?
      navigation_helpers.taxon_breadcrumbs
    else
      navigation_helpers.breadcrumbs
    end
  end

  def present_taxonomy_sidebar?
    present_new_navigation? &&
      MainstreamContentFetcher.with_curated_sidebar.exclude?(
        @content_item['base_path']
      )
  end
  helper_method :present_taxonomy_sidebar?

  def present_new_navigation?
    if defined?(should_present_new_navigation_view?)
      should_present_new_navigation_view?
    end
  end
  helper_method :present_new_navigation?

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
end
