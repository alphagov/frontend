require 'gds_api/helpers'

class ApplicationController < ActionController::Base
  include GdsApi::Helpers
  include Slimmer::Headers
  include Slimmer::Template
  include Slimmer::GovukComponents
  include TaxonomyNavigation

  rescue_from GdsApi::TimedOutException, with: :error_503
  rescue_from GdsApi::EndpointNotFound, with: :error_503
  rescue_from GdsApi::HTTPErrorResponse, with: :error_503
  rescue_from GdsApi::HTTPGone, with: :error_410
  rescue_from GdsApi::HTTPNotFound, with: :cacheable_404
  rescue_from GdsApi::InvalidUrl, with: :cacheable_404
  rescue_from RecordNotFound, with: :cacheable_404

  slimmer_template 'wrapper'

  attr_accessor :navigation_helpers, :navigation

  helper_method(
    :breadcrumbs,
    :navigation_helpers,
    :should_present_taxonomy_navigation?,
  )

protected

  def error_410; error :gone; end

  def error_503(e); error(:service_unavailable, e); end

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

  def setup_content_item(base_path)
    @content_item = content_store.content_item(base_path).to_hash
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

    if should_present_taxonomy_navigation?(@content_item)
      navigation_helpers.taxon_breadcrumbs
    else
      navigation_helpers.breadcrumbs
    end
  end

  def show_tasklist_sidebar?
    if defined?(should_show_tasklist_sidebar?)
      should_show_tasklist_sidebar?
    end
  end
  helper_method :show_tasklist_sidebar?

  def show_tasklist_header?
    if defined?(should_show_tasklist_header?)
      should_show_tasklist_header?
    end
  end
  helper_method :show_tasklist_header?

  def configure_current_task(config)
    tasklist = config[:tasklist]

    config[:tasklist] = set_task_as_active_if_current_page(tasklist)

    config
  end

private

  def set_task_as_active_if_current_page(tasklist)
    counter = 0
    tasklist[:groups].each do |grouped_steps|
      grouped_steps.each do |step|
        counter = counter + 1

        step[:panel_links].each do |link|
          if link[:href] == request.path
            link[:active] = true
            tasklist[:open_step] = counter
          else
            link.delete(:active)
          end
        end
      end
    end
    tasklist
  end

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
