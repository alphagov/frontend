require "slimmer/headers"

class GuideController < ApplicationController
  before_filter :redirect_if_api_request
  before_filter -> { set_expiry unless viewing_draft_content? }

  def show
    setup_content_item_and_navigation_helpers("/" + params[:slug])
    @publication = PublicationPresenter.new(artefact)
    @publication.current_part = params[:part]
    @edition = params[:edition]
    set_language_from_publication(@publication)

    if @publication.empty_part_list?
      raise RecordNotFound
    elsif part_requested_but_no_parts? || (@publication.parts && part_requested_but_not_found?)
      return redirect_to publication_path(slug: @publication.slug)
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

  def artefact
    @_artefact ||= ArtefactRetrieverFactory.artefact_retriever.fetch_artefact(
      params[:slug],
      params[:edition]
    )
  end

  def redirect_if_api_request
    redirect_to "/api/#{params[:slug]}.json" if request.format.json?
  end

  def set_language_from_publication(publication)
    I18n.locale = publication.language if publication.language
  end

  def viewing_draft_content?
    params.include?('edition')
  end

  def part_requested_but_no_parts?
    params[:part] && (@publication.parts.nil? || @publication.parts.empty?)
  end

  def part_requested_but_not_found?
    params[:part] && ! @publication.find_part(params[:part])
  end
end
