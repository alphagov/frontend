class BrowseController < ApplicationController

  def section
    # TODO: What do we do when it's just to /browse?
    if params[:section].nil?
      error 404
    end

    @category = content_api.tag(params[:section])
    response = content_api.sub_sections(params[:section])
    @sub_categories = response.results
    setup_page_title(@category.title)
    options = {title: "browse", section_name: "#{@category.title}", section_link: "/browse"}
    set_slimmer_dummy_artefact(options)
  end

  def sub_section
    # fill_in_slimmer_headers("Section nav")
  end

protected
  def setup_page_title(category=nil)
    @page_title = category.nil? ? "Browse | GOV.UK Beta (Test)" : "#{category} | GOV.UK Beta (Test)"
  end

end
