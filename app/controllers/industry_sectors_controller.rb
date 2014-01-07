class IndustrySectorsController < ApplicationController

  TAG_TYPE = "industry_sector"

  def sector
    @sector = content_api.tag(params[:sector], TAG_TYPE.pluralize)
    @child_tags = content_api.child_tags(TAG_TYPE, params[:sector])

    set_slimmer_headers(format: "industry-sector")
  end

  def subcategory
    @tag_id = "#{params[:sector]}/#{params[:subcategory]}"

    @subcategory = content_api.tag(@tag_id, TAG_TYPE.pluralize)
    @sector = @subcategory.parent

    @results = content_api.sorted_by(@tag_id, "curated", TAG_TYPE).results

    set_slimmer_dummy_artefact(section_name: @sector.title, section_link: "/#{params[:sector]}")
    set_slimmer_headers(format: "industry-sector")
  end

end
