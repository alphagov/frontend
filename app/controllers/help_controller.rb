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
    set_headers_from_publication(@publication)
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

  # duplicated from root_controller.rb#222
  def set_headers_from_publication(publication)
    I18n.locale = publication.language if publication.language
    set_expiry if(params.exclude?('edition') && request.get?)
    deny_framing if deny_framing?(publication)
  end

  def deny_framing
    response.headers['X-Frame-Options'] = 'DENY'
  end

  def deny_framing?(publication)
    ['transaction', 'local_transaction'].include? publication.format
  end
end
