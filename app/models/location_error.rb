class LocationError
  attr_reader :postcode_error, :message, :sub_message, :message_args

  def initialize(postcode_error = nil, message_args = {})
    @postcode_error = postcode_error
    @message_args = message_args

    case postcode_error
    when "fullPostcodeNoMapitMatch"
      @message = "formats.local_transaction.valid_postcode_no_match"
      @sub_message = "formats.local_transaction.valid_postcode_no_match_sub_html"
    when "noLaMatch"
      @message = "formats.local_transaction.no_local_authority"
      @sub_message = ""
    when "validPostcodeNoLocation"
      # This is a find my nearest exception when no location is found
      @message = "formats.find_my_nearest.valid_postcode_no_locations"
      @sub_message = "" # not used in the markup for this case
    else # e.g. 'invalidPostcodeFormat' both local transaction and from Imminence
      @message = "formats.local_transaction.invalid_postcode"
      @sub_message = "formats.local_transaction.invalid_postcode_sub"
    end

    send_error_notification(postcode_error) if postcode_error
  end

  def send_error_notification(error)
    ActiveSupport::Notifications.instrument("postcode_error_notification", postcode_error: error)
  end
end
