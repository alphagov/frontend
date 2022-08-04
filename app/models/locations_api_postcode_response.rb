class LocationsApiPostcodeResponse
  attr_reader :local_custodian_codes, :error, :postcode

  def initialize(postcode, local_custodian_codes, error)
    @postcode = postcode
    @local_custodian_codes = local_custodian_codes
    @error = error
  end

  def location_found?
    local_custodian_codes.present?
  end

  def location_not_found?
    postcode && local_custodian_codes.empty? && error.nil?
  end

  def invalid_postcode?
    postcode && local_custodian_codes.nil? && error.present?
  end

  def blank_postcode?
    postcode.blank?
  end
end
