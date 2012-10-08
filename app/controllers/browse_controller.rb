class BrowseController < ApplicationController

  rescue_from GdsApi::HTTPNotFound, with: lambda {
    statsd.increment("browse.not_found")
    error_404
  }

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
    options = {title: "browse", section_name: "#{@category.title}", section_link: "/browse/#{params[:section]}"}
    set_slimmer_artefact_headers(options)
  end

  def sub_section
    tag_id = "#{params[:section]}/#{params[:sub_section]}"
    @sub_category = content_api.tag(tag_id)
    return error_404 unless @sub_category

    @category = @sub_category.parent
    @results = content_api.sorted_by(tag_id, "alphabetical").results

    detailed_guidance_sections(tag_id)

    setup_page_title(@sub_category.title)
    options = {
      title: "browse",
      section_name: "#{@sub_category.title}",
      section_link: "/browse/#{params[:section]}/#{params[:sub_section]}",
      parent: {
        section_name: @category.title,
        section_link: "/browse/#{params[:section]}"
      }
    }
    set_slimmer_artefact_headers(options)
  end

protected
  def set_slimmer_artefact_headers(dummy_artefact)
    set_slimmer_headers(format: 'browse')
    set_slimmer_dummy_artefact(dummy_artefact)
  end

  def setup_page_title(category=nil)
    @page_title = category.nil? ? "Browse - GOV.UK Beta (Test)" : "#{category} - GOV.UK Beta (Test)"
  end

  def detailed_guidance_sections(tag_id)
    begin
      @detailed_categories = Frontend.detailed_guidance_content_api.sub_sections(tag_id).results
      @detailed_categories.sort_by! { |category| category.title }
    rescue GdsApi::HTTPErrorResponse
      @detailed_categories = []
    end
  end

end
