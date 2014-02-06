class BrowseController < ApplicationController

  rescue_from GdsApi::HTTPNotFound, with: lambda {
    statsd.increment("browse.not_found")
    error_404
  }

  before_filter(:only => [:section, :sub_section]) { validate_slug_param(:section) }
  before_filter(:only => [:sub_section]) { validate_slug_param(:sub_section) }
  before_filter :set_expiry

  def index
    setup_page_title("All categories")
    @categories = content_api.root_sections.results.sort_by { |category| category.title }
    options = {title: "browse", section_name: "Browse", section_link: "/browse"}
    set_slimmer_artefact_headers(options)
  end

  def section
    @category = content_api.tag(params[:section])
    return error_404 unless @category

    response = content_api.sub_sections(params[:section])
    @sub_categories = response.results.sort_by { |category| category.title }
    setup_page_title(@category.title)
    set_slimmer_artefact_headers
    render_section_view
  end

  def sub_section
    @tag_id = "#{params[:section]}/#{params[:sub_section]}"
    @sub_category = content_api.tag(@tag_id)
    return error_404 unless @sub_category

    @category = @sub_category.parent
    @results = content_api.sorted_by(@tag_id, "curated").results

    detailed_guidance_sections(@tag_id)

    setup_page_title(@sub_category.title)
    options = {title: "browse", section_name: @category.title, section_link: "/browse/#{params[:section]}"}
    set_slimmer_artefact_headers(options)
  end

protected
  def set_slimmer_artefact_headers(dummy_artefact={})
    set_slimmer_headers(format: 'browse')
    set_slimmer_dummy_artefact(dummy_artefact) unless dummy_artefact.empty?
  end

  def setup_page_title(category=nil)
    @page_title = category.nil? ? "Browse - GOV.UK" : "#{category} - GOV.UK"
  end

  def detailed_guidance_sections(tag_id)
    begin
      @detailed_categories = Frontend.detailed_guidance_content_api.sub_sections(tag_id).results
      @detailed_categories.sort_by! { |category| category.title }
    rescue GdsApi::HTTPErrorResponse
      @detailed_categories = []
    end
  end

  def render_section_view
    if params[:section] == 'business'
      render :business
    elsif params[:section] == 'visas-immigration'
      render 'visas-immigration'
    else
      render :section
    end
  end
end
