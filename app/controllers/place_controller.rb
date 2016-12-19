class PlaceController < ApplicationController
  include ApiRedirectable
  include Previewable

  before_filter -> { set_expiry unless viewing_draft_content? }
  before_filter -> { setup_content_item_and_navigation_helpers("/" + params[:slug]) }

  helper_method :postcode_provided?, :postcode

  INVALID_POSTCODE_ERROR = "invalidPostcodeError".freeze
  NO_LOCATION_ERROR = "validPostcodeNoLocation".freeze

  REPORT_CHILD_ABUSE_SLUG = "report-child-abuse-to-local-council".freeze

  def show
    @publication = publication

    render :show, locals: locals
  end

private

  def publication
    if postcode_provided?
      PublicationWithPlacesPresenter.new(artefact, places)
    else
      super
    end
  end

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
    params[:postcode].present?
  end

  def postcode
    PostcodeSanitizer.sanitize(params[:postcode])
  end

  def places
    places = Frontend.imminence_api.places_for_postcode(artefact["details"]["place_type"], postcode, Frontend::IMMINENCE_QUERY_LIMIT)
    @location_error = LocationError.new(NO_LOCATION_ERROR) if places.blank?
    places
  rescue GdsApi::HTTPErrorResponse => e
    if imminence_error_for_invalid_postcode?(e)
      @location_error = LocationError.new(INVALID_POSTCODE_ERROR)
    elsif imminence_error_for_no_mapit_location?(e)
      @location_error = LocationError.new(NO_LOCATION_ERROR)
    else
      raise
    end
  end

  def imminence_error_for_invalid_postcode?(error)
    error.error_details.fetch("error") == INVALID_POSTCODE_ERROR
  end

  def imminence_error_for_no_mapit_location?(error)
    error.error_details.fetch("error") == NO_LOCATION_ERROR
  end
end
