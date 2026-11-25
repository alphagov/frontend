require "ostruct"

class PostcodeLookup
  ORDNANCE_SURVEY_CUSTODIAN_CODE = 7655

  class PostcodeError < StandardError; end

  class PostcodeCrownDependency < PostcodeError; end
  class PostcodeInvalid < PostcodeError; end
  class PostcodeNoResults < PostcodeError; end
  class PostcodeNotFound < PostcodeError; end

  attr_reader :postcode

  def initialize(postcode)
    @postcode = postcode
    raise PostcodeInvalid if postcode.blank?

    response = Frontend.locations_api.results_for_postcode(postcode)
    raise PostcodeCrownDependency if response["postcode_category"] == "CROWN_DEPENDENCY"

    @results = response["results"] || []
    @results.delete_if { it["local_custodian_code"] == ORDNANCE_SURVEY_CUSTODIAN_CODE }

    raise PostcodeNoResults if @results.empty?
  rescue GdsApi::HTTPNotFound
    raise PostcodeNotFound
  rescue GdsApi::HTTPClientError
    raise PostcodeInvalid
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
