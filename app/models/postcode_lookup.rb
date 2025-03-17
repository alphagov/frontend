require "ostruct"

class PostcodeLookup
  attr_reader :local_custodian_codes, :postcode

  def initialize(postcode)
    @postcode = postcode
    raise LocationError, "invalidPostcodeFormat" if postcode.blank?

    @local_custodian_codes = Frontend.locations_api.local_custodian_code_for_postcode(postcode)
    raise LocationError, "noLaMatch" if @local_custodian_codes.empty?
  rescue GdsApi::HTTPNotFound
    raise LocationError, "noLaMatch"
  rescue GdsApi::HTTPClientError
    raise LocationError, "invalidPostcodeFormat"
  end

  def addresses
    @addresses ||= begin
      response = Frontend.locations_api.results_for_postcode(postcode)
      response["results"].map do |result|
        OpenStruct.new(
          address: result["address"],
          local_custodian_code: result["local_custodian_code"],
        )
      end
    end
  end
end
