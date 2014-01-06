class SectorsController < ApplicationController

  def sector
    @sector = content_api.tag(params[:sector], "sectors")
    @child_tags = content_api.child_tags("sector", params[:sector])
  end

  def sub_sector
    @tag_id = "#{params[:sector]}/#{params[:sub_sector]}"
    @sub_sector = content_api.tag(@tag_id, "sectors")
    @sector = @sub_sector.parent

    @results = content_api.sorted_by(@tag_id, "curated", "sector").results
  end

end
