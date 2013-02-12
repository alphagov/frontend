class TravelAdviceController < ApplicationController
  before_filter :set_expiry

  def index
    @countries = sort_countries(content_api.countries['results'])
    @publication = OpenStruct.new(:type => 'travel-advice')

    respond_to do |format|
      format.html
      format.atom do
        @countries
      end
      format.json { redirect_to "/api/travel-advice.json" }
    end
  end

  def country
    @country = params[:country_slug].dup
    @edition = params[:edition]

    @publication, @artefact = fetch_artefact_and_publication_for_country(@country)
    set_slimmer_artefact_headers(@artefact)

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
    set_expiry(10.minutes)
    error 404
  end

  private

  def fetch_artefact_and_publication_for_country(country)
    params[:slug] = "travel-advice/" + country

    artefact = fetch_artefact
    publication = PublicationPresenter.new(artefact)

    return [publication, artefact]
  end

  def sort_countries(countries)
    countries.reject do |c|
      c['updated_at'].nil?
    end.sort do |x, y|
      y['updated_at'] <=> x['updated_at']
    end
  end
end
