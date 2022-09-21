class ImminenceResponse
  INVALID_POSTCODE = "invalidPostcodeError".freeze
  NO_LOCATION = "validPostcodeNoLocation".freeze

  attr_reader :places, :error, :postcode

  def initialize(postcode, places, error)
    @postcode = postcode
    @places = places
    @error = error
  end

  def places_found?
    places.present?
  end

  def places_not_found?
    postcode && (places.blank? || no_location?)
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
