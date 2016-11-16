require "slimmer/headers"

class AnswerController < ApplicationController
  before_filter :set_expiry
  before_filter :redirect_if_api_request

  def show
    setup_content_item_and_navigation_helpers("/" + params[:slug])
    @publication = PublicationPresenter.new(artefact)
    @edition = params[:edition]
    set_language_from_publication(@publication)
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

  def set_expiry
    return if viewing_draft_content?
    return unless request.get?
    super
  end

  def viewing_draft_content?
    params.include?('edition')
  end
end
