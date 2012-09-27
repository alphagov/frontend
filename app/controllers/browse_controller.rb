class BrowseController < ApplicationController

  def section
    # TODO: What do we do when it's just to /browse?
    if params[:section].nil?
      error 404
    end

    # Get Section tag with tag_id @section
    @category = content_api.tag(params[:section])
    # Get all the tags who have a parent of @section
    response = content_api.sub_sections(params[:section])
    @sub_categories = response.results

    # Is this still right??
    fill_in_slimmer_headers("Section nav")
  end

  def sub_section
    fill_in_slimmer_headers("Section nav")
  end

  protected
  def retrieve_results(term, limit = 50, format_filter = nil)
    res = Frontend.mainstream_search_client.search(term, format_filter).take(limit)
    res.map { |r| SearchResult.new(r) }
  end

  def fill_in_slimmer_headers(section)
    set_slimmer_headers(
      section: section,
      format: "search",
      section: "search",
      proposition: "citizen"
    )
  end
end
