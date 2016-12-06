class TravelAdviceController < ApplicationController
  before_filter(only: [:country]) { validate_slug_param(:country_slug) }
  before_filter(only: [:country]) { validate_slug_param(:part) if params[:part] }
  before_filter :redirect_if_api_request, only: :index

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

  # Travel advice country pages are still served in draft mode from this application,
  # because the draft stack doesn't support previewing multiple editions yet.
  def country
    set_expiry(5.minutes)

    @country = params[:country_slug].dup
    @edition = params[:edition]

    @publication = fetch_publication_for_country(@country)

    I18n.locale = :en # These pages haven't been localised yet.

    if params[:part].present?
      @publication.current_part = params[:part]
      unless @publication.current_part
        redirect_to travel_advice_country_path(@country) and return
      end
    end

    request.variant = :print if params[:variant].to_s == "print"

    respond_to do |format|
      format.atom
      format.html.none
      format.html.print do
        set_slimmer_headers template: "print"
        render layout: "application.print"
      end
    end
  end

private

  def redirect_if_api_request
    redirect_to "/api/#{FOREIGN_TRAVEL_ADVICE_SLUG}.json" if request.format.json?
  end

  def fetch_publication_for_country(country)
    artefact = fetch_artefact(FOREIGN_TRAVEL_ADVICE_SLUG + "/" + country, params[:edition])
    TravelAdviceCountryPresenter.new(artefact)
  end
end
