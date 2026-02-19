require "ostruct"

class PostcodeLookup
  attr_reader :local_custodian_codes, :postcode

  def initialize(postcode)
    @postcode = postcode
    raise LocationError, "invalidPostcodeFormat" if postcode.blank?

    @local_custodian_codes = Frontend.locations_api.local_custodian_code_for_postcode(postcode)

    raise LocationError, "noLaMatch" if @local_custodian_codes.empty?

    log_7655_codes
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

  def log_7655_codes
    return unless @local_custodian_codes.include?(7655)

    GovukError.notify(
      "Postcode results included Ordnance Survey Local Custodian Code (7655)",
      extra: {
        local_custodian_codes: @local_custodian_codes,
        postcode: @postcode,
      },
      level: "warning",
    )
  end
end
