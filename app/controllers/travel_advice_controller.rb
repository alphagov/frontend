class TravelAdviceController < ApplicationController

  before_filter :set_expiry

  def country
    @country = params[:country_slug].dup
    @edition = params[:edition]

    @publication, @artefact = fetch_artefact_and_publication_for_country(@country)
    set_slimmer_artefact_headers(@artefact)

    I18n.locale = @publication.language if @publication.language

    if @publication.parts
      part = params.fetch(:part) { @publication.parts.first.slug }
      @part = @publication.find_part(part)

      unless @part
        redirect_to travel_advice_country_path(@country) and return
      end
    else
      @publication.parts = [ build_initial_part ]
      @part = @publication.parts.first
    end

    respond_to do |format|
      format.html { render "country" }
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

      raise RecordNotFound unless publication
      return [publication, artefact]
    end

    def build_initial_part
      PartPresenter.new(
        'slug' => "summary",
        'title' => "Summary",
        'body' => "",
        'name' => "Summary"
      )
    end

end
