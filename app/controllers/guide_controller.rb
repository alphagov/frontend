class GuideController < ApplicationController
  include ApiRedirectable
  include Previewable

  before_filter -> { set_expiry unless viewing_draft_content? }
  before_filter -> { setup_content_item_and_navigation_helpers("/" + params[:slug]) }

  def show
    @publication = publication
    @publication.current_part = params[:part]
    set_language_from_publication

    if @publication.empty_part_list?
      raise RecordNotFound
    elsif part_requested_but_no_parts? || (@publication.parts && part_requested_but_not_found?)
      return redirect_to guide_path(slug: @publication.slug)
    end

    request.variant = :print if params[:variant].to_s == "print"

    respond_to do |format|
      format.html.none
      format.html.print do
        set_slimmer_headers template: "print"
        render :show, layout: "application.print"
      end
    end
  end

private

  def part_requested_but_no_parts?
    params[:part] && (@publication.parts.nil? || @publication.parts.empty?)
  end

  def part_requested_but_not_found?
    params[:part] && ! @publication.find_part(params[:part])
  end
end
