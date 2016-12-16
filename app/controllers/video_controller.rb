require "slimmer/headers"

class VideoController < ApplicationController
  include ApiRedirectable
  include Previewable

  before_filter -> { set_expiry unless viewing_draft_content? }
  before_filter -> { setup_content_item_and_navigation_helpers("/" + params[:slug]) }

  def show
    @publication = PublicationPresenter.new(artefact)
    set_language_from_publication(@publication)
  end

  private

  def artefact
    @_artefact ||= ArtefactRetrieverFactory.artefact_retriever.fetch_artefact(
      params[:slug],
      params[:edition]
    )
  end

  def set_language_from_publication(publication)
    I18n.locale = publication.language if publication.language
  end
end
