class TravelAdviceController < ApplicationController
  before_filter :redirect_if_api_request

  FOREIGN_TRAVEL_ADVICE_SLUG = 'foreign-travel-advice'.freeze

  def index
    set_expiry
    setup_content_item_and_navigation_helpers("/" + FOREIGN_TRAVEL_ADVICE_SLUG)
    @presenter = TravelAdviceIndexPresenter.new(@content_item)

    respond_to do |format|
      format.html { render locals: { full_width: true } }
      format.atom { set_expiry(5.minutes) }
    end
  end

private

  def redirect_if_api_request
    redirect_to "/api/#{FOREIGN_TRAVEL_ADVICE_SLUG}.json" if request.format.json?
  end

  def artefact
    @_artefact ||= ArtefactRetrieverFactory.artefact_retriever.fetch_artefact(
      FOREIGN_TRAVEL_ADVICE_SLUG + "/" + @country,
      params[:edition]
    )
  end
end
