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
    tag_id = "#{params[:section]}/#{params[:sub_section]}"
    @sub_category = content_api.tag(tag_id)

    @category = @sub_category.parent
    @results = content_api.curated_list(tag_id).results

    setup_page_title(@sub_category.title)
    options = {title: "browse", section_name: "#{@sub_category.title}", section_link: "/browse/#{params[:section]}/#{params[:sub_section]}"}
    set_slimmer_dummy_artefact(options)
  end

protected
  def setup_page_title(category=nil)
    @page_title = category.nil? ? "Browse | GOV.UK Beta (Test)" : "#{category} | GOV.UK Beta (Test)"
  end

end
