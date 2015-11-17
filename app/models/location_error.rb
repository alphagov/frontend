class LocationError
  attr_reader :postcode_error, :message

  def initialize(postcode_error = nil, message = nil)
    @postcode_error = postcode_error
    @message = message || 'formats.local_transaction.invalid_postcode'
    log_error
  end

  def log_error
    Rails.logger.info(postcode_error) if postcode_error
  end
end
