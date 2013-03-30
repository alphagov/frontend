class TravelAdviceController < ApplicationController

  before_filter(:only => [:country]) { validate_slug_param(:country_slug) }
  before_filter { set_expiry(5.minutes) }

  def index
    @artefact = fetch_artefact('foreign-travel-advice')
    set_slimmer_artefact_headers(@artefact, :beta => '1')

    @publication = TravelAdviceIndexPresenter.new(@artefact)

    respond_to do |format|
      format.html
      format.atom
      format.json { redirect_to "/api/foreign-travel-advice.json" }
    end
  end

  def country
    @country = params[:country_slug].dup
    @edition = params[:edition]

    @publication, @artefact = fetch_artefact_and_publication_for_country(@country)
    set_slimmer_artefact_overriding_section(@artefact, :section_name => "Foreign travel advice", :section_link => "/foreign-travel-advice")
    set_slimmer_headers(:format => @artefact["format"], :beta => '1')

    I18n.locale = :en # These pages haven't been localised yet.

    if params[:part].present?
      @part = @publication.find_part(params[:part])

      unless @part
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

  def fetch_artefact_and_publication_for_country(country)
    params[:slug] = "foreign-travel-advice/" + country

    artefact = fetch_artefact(params[:slug], params[:edition])
    publication = TravelAdviceCountryPresenter.new(artefact)

    return [publication, artefact]
  end
end
