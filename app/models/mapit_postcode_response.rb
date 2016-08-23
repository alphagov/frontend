class MapitPostcodeResponse
  attr_reader :location, :error, :postcode

  def initialize(postcode, location, error)
    @postcode = postcode
    @location = location
    @error = error
  end

  def location_found?
    location.present?
  end

  def location_not_found?
    postcode && location.nil? && error.nil?
  end

  def invalid_postcode?
    postcode && location.nil? && error.present?
  end

  def blank_postcode?
    postcode.blank?
  end

  def areas_found?
    location.areas.present?
  end
end
