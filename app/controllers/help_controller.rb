require "slimmer/headers"

class HelpController < ApplicationController
  before_filter :set_expiry
  before_filter :redirect_if_api_request

  def index
    setup_content_item_and_navigation_helpers("/help")

    respond_to do |format|
      format.html
      format.json { redirect_to "/api/help.json" }
    end
  end

  def tour
    setup_content_item_and_navigation_helpers("/tour")
    render locals: { full_width: true }
  end

  def show
    setup_content_item_and_navigation_helpers("/" + params[:slug])
    @publication = PublicationPresenter.new(artefact)
    @edition = params[:edition]
    set_language_from_publication(@publication)
    render :show
  end

private

  def artefact
    @_artefact ||= ArtefactRetrieverFactory.artefact_retriever.fetch_artefact(
      params[:slug],
      params[:edition]
    )
  end

  def redirect_if_api_request
    slug = params[:slug] || 'help'
    redirect_to "/api/#{slug}.json" if request.format.json?
  end

  def set_language_from_publication(publication)
    I18n.locale = publication.language if publication.language
  end

  def set_expiry
    return if viewing_draft_content?
    return unless request.get?
    super
  end

  def viewing_draft_content?
    params.include?('edition')
  end
end
