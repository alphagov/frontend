class SpecialistSectorsController < ApplicationController

  TAG_TYPE = "specialist_sector"

  before_filter(:only => [:sector, :subcategory]) { validate_slug_param(:sector) }
  before_filter(:only => [:subcategory]) { validate_slug_param(:subcategory) }
  before_filter :set_expiry
  before_filter :set_beta_header

  def sector
    @sector = content_api.tag(params[:sector], TAG_TYPE)
    return error_404 unless @sector.present?

    @child_tags = content_api.child_tags(TAG_TYPE, params[:sector])

    set_slimmer_headers(format: "specialist-sector")
  end

  def subcategory
    @tag_id = "#{params[:sector]}/#{params[:subcategory]}"

    @subcategory = content_api.tag(@tag_id, TAG_TYPE)
    return error_404 unless @subcategory.present?

    @sector = @subcategory.parent
    @groups = content_api.with_tag(@tag_id, TAG_TYPE, group_by: "format").grouped_results

    set_slimmer_dummy_artefact(section_name: @sector.title, section_link: "/#{params[:sector]}")
    set_slimmer_headers(format: "specialist-sector")
  end

  private
  def set_beta_header
    response.header[Slimmer::Headers::BETA_LABEL] = "after:.page-header"
  end

end
