class PlaceController < ApplicationController
  include ApiRedirectable
  include Previewable
  include Cacheable
  include Navigable

  before_filter :set_publication

  helper_method :postcode_provided?, :postcode

  INVALID_POSTCODE = "invalidPostcodeError".freeze
  NO_LOCATION = "validPostcodeNoLocation".freeze

  REPORT_CHILD_ABUSE_SLUG = "report-child-abuse-to-local-council".freeze

  def show
    set_content_item(PlacePresenter)
    if request.post?
      @location_error = location_error
      if @location_error
        @postcode = postcode
      elsif imminence_response.places_found?
        @publication = PublicationWithPlacesPresenter.new(artefact, imminence_response.places)
      end
    end

    render :show, locals: locals
  end

private

  def locals
    if params[:slug] == REPORT_CHILD_ABUSE_SLUG
      {
        option_partial: "option_report_child_abuse",
        preposition: "for"
      }
    else
      {}
    end
  end

  def postcode_provided?
    params[:postcode].present? && request.post?
  end

  def postcode
    PostcodeSanitizer.sanitize(params[:postcode])
  end

  def location_error
    return LocationError.new(INVALID_POSTCODE) if imminence_response.invalid_postcode? || imminence_response.blank_postcode?
    return LocationError.new(NO_LOCATION) if imminence_response.places_not_found?
  end

  def imminence_response
    @_imminence_response ||= places_from_imminence
  end

  def places_from_imminence
    if postcode.present?
      begin
        places = Frontend.imminence_api.places_for_postcode(artefact["details"]["place_type"], postcode, Frontend::IMMINENCE_QUERY_LIMIT)
      rescue GdsApi::HTTPErrorResponse => e
        error = e
      end
    end
    ImminenceResponse.new(postcode, places, error)
  end
end
