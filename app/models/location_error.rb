class LocationError
  attr_reader :postcode_error, :message, :message_args

  def initialize(postcode_error = nil, message = nil, message_args = {})
    @postcode_error = postcode_error
    @message = message || 'formats.local_transaction.invalid_postcode'
    @message_args = message_args
    log_error
  end

  def log_error
    Rails.logger.info(postcode_error) if postcode_error
  end

  def no_location_interaction?
    postcode_error == "laMatchNoLink"
  end
end
