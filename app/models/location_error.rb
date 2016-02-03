class LocationError
  attr_reader :postcode_error, :message, :sub_message, :message_args

  def initialize(postcode_error = nil, message_args = {})
    @postcode_error = postcode_error
    @message_args = message_args

    case postcode_error
    when 'fullPostcodeNoMapitMatch'
      @message = 'formats.local_transaction.valid_postcode_no_match'
      @sub_message = 'formats.local_transaction.valid_postcode_no_match_sub_html'
    when 'noLaMatchLinkToFindLa'
      @message = 'formats.local_transaction.no_local_authority'
      @sub_message = 'formats.local_transaction.no_local_authority_sub_html'
    when 'laMatchNoLink'
      @message =
        if local_authority_name_starts_with_a_the?
          'formats.local_transaction.local_authority_starts_with_the_no_service_url_html'
        else
          'formats.local_transaction.local_authority_no_service_url_html'
        end
      @sub_message = '' #not used in the markup for this case
    when 'laMatchNoLinkNoAuthorityUrl'
      @message =
        if local_authority_name_starts_with_a_the?
          'formats.local_transaction.local_authority_starts_with_the_no_service_url_no_authority_link_html'
        else
          'formats.local_transaction.local_authority_no_service_url_no_authority_link_html'
        end

      @sub_message = '' #not used in the markup for this case
    else # e.g. 'invalidPostcodeFormat'
      @message = 'formats.local_transaction.invalid_postcode'
      @sub_message = 'formats.local_transaction.invalid_postcode_sub'
    end

    send_error_notification(postcode_error) if postcode_error
  end

  def send_error_notification(error)
    ActiveSupport::Notifications.instrument('postcode_error_notification', postcode_error: error)
  end

  def no_location_interaction?
    %w(laMatchNoLink laMatchNoLinkNoAuthorityUrl).include? postcode_error
  end

private

  def local_authority_name_starts_with_a_the?
    message_args.fetch(:local_authority_name, '') =~ /\Athe/i
  end
end
