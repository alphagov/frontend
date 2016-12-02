require "slimmer/headers"

class PlaceController < ApplicationController
  before_filter :redirect_if_api_request
  before_filter -> { set_expiry unless viewing_draft_content? }

  CUSTOM_SLUGS = {
    "report-child-abuse-to-local-council" => {
      locals: {
        option_partial: "option_report_child_abuse",
        preposition: "for",
      }
    },
  }.freeze

  def self.custom_slugs; CUSTOM_SLUGS; end

  def show
    setup_content_item_and_navigation_helpers("/" + params[:slug])
    @edition = params[:edition]

    if !postcode_provided?
      @publication = PublicationPresenter.new(artefact)
    else
      @publication = PublicationPresenter.new(artefact, places)
      @postcode = params[:postcode]
    end

    if is_custom_slug?
      render :show, locals: custom_slug_locals
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

  def postcode
    PostcodeSanitizer.sanitize(params[:postcode])
  end

  def postcode_provided?
    params[:postcode].present?
  end

  def redirect_if_api_request
    redirect_to "/api/#{params[:slug]}.json" if request.format.json?
  end

  def viewing_draft_content?
    params.include?('edition')
  end

  def places
    places = Frontend.imminence_api.places_for_postcode(artefact.details.place_type, postcode, Frontend::IMMINENCE_QUERY_LIMIT)
    @location_error = LocationError.new("validPostcodeNoLocation") if places.blank?
    places
  rescue GdsApi::HTTPErrorResponse => e
    # allow 400 errors, as they can be invalid postcodes or no locations found
    @location_error = LocationError.new(e.error_details["error"]) unless e.error_details.nil?
    raise unless e.code == 400
  end

  def is_custom_slug?
    self.class.custom_slugs.key?(params[:slug])
  end

  def custom_slug_locals
    self.class.custom_slugs[params[:slug]][:locals]
  end
end
