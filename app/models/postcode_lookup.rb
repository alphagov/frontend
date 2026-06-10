require "ostruct"

class PostcodeLookup
  ORDNANCE_SURVEY_CUSTODIAN_CODE = 7655

  attr_reader :postcode

  def initialize(postcode)
    @postcode = postcode
    raise LocationError, "invalidPostcodeFormat" if postcode.blank?

    response = Frontend.locations_api.results_for_postcode(postcode)
    @results = response["results"] || []
    @results.delete_if { it["local_custodian_code"] == ORDNANCE_SURVEY_CUSTODIAN_CODE }

    raise LocationError, "noLaMatch" if @results.empty?
  rescue GdsApi::HTTPNotFound
    raise LocationError, "noLaMatch"
  rescue GdsApi::HTTPClientError
    raise LocationError, "invalidPostcodeFormat"
  end

  def local_custodian_codes
    @results.map { |r| r["local_custodian_code"] }.uniq
  end

  def addresses
    @addresses ||= @results.map do |result|
      OpenStruct.new(
        address: result["address"],
        local_custodian_code: result["local_custodian_code"],
      )
    end
  end
end
