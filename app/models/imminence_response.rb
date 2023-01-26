class ImminenceResponse
  INVALID_POSTCODE = "invalidPostcodeError".freeze
  NO_LOCATION = "validPostcodeNoLocation".freeze

  attr_reader :places, :addresses, :error, :postcode

  def initialize(postcode, places, addresses, error)
    @postcode = postcode
    @error = error
    @places = places
    @addresses = addresses
  end

  def addresses_returned?
    addresses.any?
  end

  def places_found?
    places.any?
  end

  def places_not_found?
    postcode && (places.empty? || no_location?)
  end

  def invalid_postcode?
    error && error.error_details.fetch("error") == INVALID_POSTCODE
  end

  def blank_postcode?
    postcode.blank?
  end

private

  def no_location?
    error && error.error_details.fetch("error") == NO_LOCATION
  end
end
