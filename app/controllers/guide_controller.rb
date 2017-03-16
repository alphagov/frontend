class GuideController < ApplicationController
  include Cacheable
  include Navigable
  include EducationNavigationABTestable

  before_action -> { request.variant = :print }, if: :print_request?

  def show
    set_content_item(GuidePresenter)
    @publication.current_part = part_requested

    if @publication.empty_part_list?
      raise RecordNotFound
    elsif part_requested && @publication.part_not_found?
      return redirect_to guide_path(slug: @publication.slug)
    end

    respond_to do |format|
      format.html.none
      format.html.print do
        set_slimmer_headers template: "print"
        render :show, layout: "application.print"
      end
    end
  end

  private

  def part_requested
    params[:part]
  end

  def print_request?
    params[:variant].to_s == "print"
  end
end
