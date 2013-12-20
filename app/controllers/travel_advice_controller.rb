class TravelAdviceController < ApplicationController

  before_filter(:only => [:country]) { validate_slug_param(:country_slug) }
  before_filter(:only => [:country]) { validate_slug_param(:part) if params[:part] }

  def index
    set_expiry

    artefact = fetch_artefact('foreign-travel-advice')
    set_slimmer_artefact_headers(artefact, :format => 'travel-advice')

    @publication = TravelAdviceIndexPresenter.new(artefact)

    respond_to do |format|
      format.html
      format.atom { set_expiry(5.minutes) }
      # TODO: Doing a static redirect to the API URL here means that an API call
      #       and a variety of other logic will have been executed unnecessarily.
      #       We should move this to the top of the method or out to routes.rb for
      #       efficiency.
      format.json { redirect_to "/api/foreign-travel-advice.json" }
    end
  end

  def country
    set_expiry(5.minutes)

    @country = params[:country_slug].dup
    @edition = params[:edition]

    @publication = fetch_publication_for_country(@country)

    tags = @publication.artefact.to_hash["tags"]
    section_tag = tags.find {|t| t["details"]["type"] == "section" }

    combined_tags = slimmer_section_tag_for_details(
      :section_name => "Foreign travel advice",
      :section_link => "/foreign-travel-advice"
    ).merge("parent" => section_tag)

    if section_tag.present?
      tags[tags.index(section_tag)] = combined_tags
    else
      tags << combined_tags
    end

    set_slimmer_artefact_headers(@publication.artefact.to_hash.merge('tags' => tags))

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
