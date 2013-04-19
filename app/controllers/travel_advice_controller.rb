class TravelAdviceController < ApplicationController

  before_filter(:only => [:country]) { validate_slug_param(:country_slug) }
  before_filter { set_expiry(5.minutes) }

  def index
    artefact = fetch_artefact('foreign-travel-advice')
    set_slimmer_artefact_headers(artefact)

    @publication = TravelAdviceIndexPresenter.new(artefact)

    respond_to do |format|
      format.html
      format.atom
      # TODO: Doing a static redirect to the API URL here means that an API call
      #       and a variety of other logic will have been executed unnecessarily.
      #       We should move this to the top of the method or out to routes.rb for
      #       efficiency.
      format.json { redirect_to "/api/foreign-travel-advice.json" }
    end
  end

  def country
    @country = params[:country_slug].dup
    @edition = params[:edition]

    @publication = fetch_publication_for_country(@country)
    set_slimmer_artefact_overriding_section(@publication.artefact, :section_name => "Foreign travel advice", :section_link => "/foreign-travel-advice")
    set_slimmer_headers(:format => @publication.artefact["format"])

    I18n.locale = :en # These pages haven't been localised yet.

    if params[:part].present?
      @publication.current_part = params[:part]
      unless @publication.current_part
        redirect_to travel_advice_country_path(@country) and return
      end
    end

    respond_to do |format|
      format.html
      format.atom
      format.print do
        set_slimmer_headers template: "print"
      end
    end
  rescue RecordNotFound
    error 404
  end

  private

  def fetch_publication_for_country(country)
    artefact = fetch_artefact("foreign-travel-advice/" + country, params[:edition])
    TravelAdviceCountryPresenter.new(artefact)
  end
end
