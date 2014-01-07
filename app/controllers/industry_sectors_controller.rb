class IndustrySectorsController < ApplicationController

  TAG_TYPE = "industry_sector"

  def sector
    @sector = content_api.tag(params[:sector], TAG_TYPE.pluralize)
    @child_tags = content_api.child_tags(TAG_TYPE, params[:sector])
  end

  def sub_sector
    @tag_id = "#{params[:sector]}/#{params[:sub_sector]}"
    @sub_sector = content_api.tag(@tag_id, TAG_TYPE.pluralize)
    @sector = @sub_sector.parent

    @results = content_api.sorted_by(@tag_id, "curated", TAG_TYPE).results
  end

end
