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

    if postcode_provided? && imminence_response.addresses_returned?
      @options = imminence_response.addresses.each.map do |address|
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
    @publication ||= if postcode_provided? && imminence_response.places_found?
                       PlacePresenter.new(content_item_hash, imminence_response.places)
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
    return LocationError.new(INVALID_POSTCODE) if imminence_response.invalid_postcode?

    LocationError.new(NO_LOCATION) if imminence_response.places_not_found?
  end

  def imminence_response
    @imminence_response ||= places_from_imminence
  end

  def places_from_imminence
    imminence_response = Frontend.imminence_api.places_for_postcode(
      content_item_hash["details"]["place_type"],
      postcode,
      Frontend::PLACES_MANAGER_QUERY_LIMIT,
      local_authority_slug,
    )
    imminence_response_from_data(postcode, imminence_response, nil)
  rescue GdsApi::HTTPErrorResponse => e
    raise e unless ImminenceResponse.handled_error?(e)

    imminence_response_from_data(postcode, nil, e)
  end

  def imminence_response_from_data(postcode, imminence_response, error)
    return ImminenceResponse.new(postcode, [], [], error) if error

    imminence_data = imminence_response.to_hash
    places = []
    addresses = []

    # Temporary: allow both old and new imminence responses so that
    # we can switch over seamlessly by deploying Frontend first

    if !imminence_data.respond_to?(:key)
      # Handle old-style returned array
      # Remove this branch and temporary comment above when Imminence is switched over
      places = imminence_data
    elsif imminence_data["status"] == "ok"
      places = imminence_data["places"]
    else
      addresses = imminence_data["addresses"]
    end
    ImminenceResponse.new(postcode, places, addresses, error)
  end
end
