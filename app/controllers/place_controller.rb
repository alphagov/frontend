class PlaceController < ContentItemsController
  include Previewable
  include Cacheable

  helper_method :postcode_provided?, :postcode

  INVALID_POSTCODE = "invalidPostcodeError".freeze
  NO_LOCATION = "validPostcodeNoLocation".freeze

  def show
    render :show, locals: { results_anchor: "results" }
  end

  def find
    @location_error = location_error

    if postcode_provided? && places_manager_response.addresses_returned?
      @options = places_manager_response.addresses.each.map do |address|
        { text: address["address"], value: address["local_authority_slug"] }
      end
      @change_path = place_path(slug: params[:slug])
      @onward_path = place_find_path(slug: params[:slug], anchor: "results")
      @postcode = postcode
      return render :multiple_authorities
    end

    render :show, locals: { results_anchor: "results" }
  end

private

  helper_method :location_error

  def publication
    @publication ||= if postcode_provided? && places_manager_response.places_found?
                       PlacePresenter.new(content_item_hash, places_manager_response.places)
                     else
                       PlacePresenter.new(content_item_hash)
                     end
  end

  def postcode_provided?
    params[:postcode].present? && request.post?
  end

  def postcode
    PostcodeSanitizer.sanitize(params[:postcode])
  end

  def local_authority_slug
    params[:local_authority_slug]
  end

  def location_error
    return LocationError.new(INVALID_POSTCODE) unless postcode_provided?
    return LocationError.new(INVALID_POSTCODE) if places_manager_response.invalid_postcode?

    LocationError.new(NO_LOCATION) if places_manager_response.places_not_found?
  end

  def places_manager_response
    @places_manager_response ||= places_from_places_manager
  end

  def places_from_places_manager
    places_manager_response = Frontend.places_manager_api.places_for_postcode(
      content_item_hash["details"]["place_type"],
      postcode,
      Frontend::PLACES_MANAGER_QUERY_LIMIT,
      local_authority_slug,
    )
    places_manager_response_from_data(postcode, places_manager_response, nil)
  rescue GdsApi::HTTPErrorResponse => e
    raise e unless PlacesManagerResponse.handled_error?(e)

    places_manager_response_from_data(postcode, nil, e)
  end

  def places_manager_response_from_data(postcode, places_manager_response, error)
    return PlacesManagerResponse.new(postcode, [], [], error) if error

    places_manager_data = places_manager_response.to_hash
    places = []
    addresses = []

    if places_manager_data["status"] == "ok"
      places = places_manager_data["places"]
    else
      addresses = places_manager_data["addresses"]
    end
    PlacesManagerResponse.new(postcode, places, addresses, error)
  end
end
