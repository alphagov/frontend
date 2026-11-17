class LocationError < StandardError
  MESSAGES = {
    "noLaMatch" => "formats.local_transaction.no_local_authority",
    "fullPostcodeNoLocationsApiMatch" => "formats.local_transaction.valid_postcode_no_match",
    "validPostcodeNoLocation" => "formats.find_my_nearest.valid_postcode_no_locations",
    "invalidPostcodeFormat" => "formats.local_transaction.invalid_postcode",
    "invalidUprnFormat" => "formats.local_transaction.invalid_uprn",
    "validPostcodeNoElectionsMatch" => "formats.local_transaction.valid_postcode_no_match",
    "validUprnNoElectionsMatch" => "formats.local_transaction.valid_uprn_no_match",
    "electoralServiceNotAvailable" => "formats.local_transaction.electoral_service_not_available",
  }.freeze

  DATA_RELATED = %w[
    noLaMatch
    fullPostcodeNoLocationsApiMatch
    validPostcodeNoLocation
    invalidPostcodeFormat
    invalidUprnFormat
    validPostcodeNoElectionsMatch
    validUprnNoElectionsMatch
  ].freeze

  attr_reader :postcode_error, :message, :message_args

  def initialize(postcode_error = nil, message_args = {})
    @postcode_error = postcode_error
    @message_args = message_args

    @message = MESSAGES[postcode_error] || "formats.local_transaction.invalid_postcode"

    super(@message)
  end

  def data_related?
    DATA_RELATED.include?(@postcode_error)
  end
end
