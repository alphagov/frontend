require "slimmer/headers"

class HelpController < ApplicationController
  include ApiRedirectable

  before_filter -> { set_expiry unless viewing_draft_content? }

  def index
    setup_content_item_and_navigation_helpers("/help")
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

  def slug_param
    params[:slug] || 'help'
  end

  def set_language_from_publication(publication)
    I18n.locale = publication.language if publication.language
  end

  def viewing_draft_content?
    params.include?('edition')
  end
end
