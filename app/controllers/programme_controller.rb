class ProgrammeController < ApplicationController
  include ApiRedirectable
  include Previewable
  include Cacheable
  include Navigable

  before_filter :set_publication

  def show
    @publication.current_part = params[:part]

    if @publication.empty_part_list?
      raise RecordNotFound
    elsif part_requested_but_no_parts? || (@publication.parts && part_requested_but_not_found?)
      return redirect_to programme_path(slug: @publication.slug)
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

  def set_publication
    @publication = PublicationWithPartsPresenter.new(artefact)
    set_language_from_publication
  end

  def part_requested_but_no_parts?
    params[:part] && (@publication.parts.nil? || @publication.parts.empty?)
  end

  def part_requested_but_not_found?
    params[:part] && ! @publication.find_part(params[:part])
  end
end
