require "slimmer/headers"

class TransactionController < ApplicationController
  before_filter :redirect_if_api_request
  before_filter -> { set_expiry unless viewing_draft_content? }

  JOBSEARCH_SLUGS = ["jobsearch", "chwilio-am-swydd"].freeze

  def show
    setup_content_item_and_navigation_helpers("/" + params[:slug])
    @publication = PublicationPresenter.new(artefact)
    @edition = params[:edition]
    set_language_from_publication(@publication)
    deny_framing
    if JOBSEARCH_SLUGS.include? params[:slug]
      render :jobsearch
    else
      render :show
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

  def deny_framing
    response.headers['X-Frame-Options'] = 'DENY'
  end
end
