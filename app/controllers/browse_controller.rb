class BrowseController < ApplicationController

  def index
    setup_page_title("All categories")
    @categories = content_api.root_sections.results.sort_by { |category| category.title }
    options = {title: "browse", section_name: "Browse", section_link: "/browse"}
    set_slimmer_dummy_artefact(options)
  end

  def section
    @category = content_api.tag(params[:section])
    return error_404 unless @category
    
    response = content_api.sub_sections(params[:section])
    @sub_categories = response.results.sort_by { |category| category.title }
    setup_page_title(@category.title)
    options = {title: "browse", section_name: "#{@category.title}", section_link: "/browse/#{params[:section]}"}
    set_slimmer_dummy_artefact(options)
  end

  def sub_section
    tag_id = "#{params[:section]}/#{params[:sub_section]}"
    @sub_category = content_api.tag(tag_id)
    return error_404 unless @sub_category

    @category = @sub_category.parent
    @results = content_api.sorted_by(tag_id, "alphabetical").results

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
    set_slimmer_dummy_artefact(options)
  end

protected
  def setup_page_title(category=nil)
    @page_title = category.nil? ? "Browse | GOV.UK Beta (Test)" : "#{category} | GOV.UK Beta (Test)"
  end

end
