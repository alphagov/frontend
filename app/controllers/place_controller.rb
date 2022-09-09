class PlaceController < ContentItemsController
  include Previewable
  include Cacheable

  helper_method :postcode_provided?, :postcode

  INVALID_POSTCODE = "invalidPostcodeError".freeze
  NO_LOCATION = "validPostcodeNoLocation".freeze

  REPORT_CHILD_ABUSE_SLUG = "report-child-abuse-to-local-council".freeze

  def show
    @location_error = location_error if request.post?
    render :show, locals:
  end

private

  helper_method :location_error

  def publication
    @publication ||= if request.post? && imminence_response.places_found?
                       PlacePresenter.new(content_item_hash, imminence_response.places)
                     else
                       PlacePresenter.new(content_item_hash)
                     end
  end

  def locals
    locals = {
      results_anchor: "results",
    }

    if params[:slug] == REPORT_CHILD_ABUSE_SLUG
      locals.merge!({
        option_partial: "option_report_child_abuse",
        preposition: "for",
      })
    end

    locals
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
    @imminence_response ||= places_from_imminence
  end

  def places_from_imminence
    if postcode.present?
      begin
        places = Frontend.imminence_api.places_for_postcode(content_item_hash["details"]["place_type"], postcode, Frontend::IMMINENCE_QUERY_LIMIT)
      rescue GdsApi::HTTPErrorResponse => e
        error = e
      end
    end
    ImminenceResponse.new(postcode, places, error)
  end
end
