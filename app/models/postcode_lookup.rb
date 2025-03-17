class PostcodeLookup
  attr_reader :local_custodian_codes

  def initialize(postcode)
    raise LocationError, "invalidPostcodeFormat" if postcode.blank?

    @local_custodian_codes = Frontend.locations_api.local_custodian_code_for_postcode(postcode)
    raise LocationError, "noLaMatch" if @local_custodian_codes.empty?
  rescue GdsApi::HTTPNotFound
    raise LocationError, "noLaMatch"
  rescue GdsApi::HTTPClientError
    raise LocationError, "invalidPostcodeFormat"
  end
end
