class LocationErrorTest < ActiveSupport::TestCase
  context '#initialize' do
    should 'default to default message when no message given' do
      error = LocationError.new(postcode_error = 'some_error', message = nil)
      assert_equal(error.message, 'formats.local_transaction.invalid_postcode')
    end

    context 'when given a postcode_error' do
      should 'send the postcode error as a notification' do
        ActiveSupport::Notifications.expects(:instrument).with('postcode_error_notification', postcode_error: "some_error")

        error = LocationError.new(postcode_error = 'some_error')
      end
    end

    context 'when not given a postcode_error' do
      should 'not send a postcode_error notification' do
        ActiveSupport::Notifications.expects(:instrument).never

        error = LocationError.new
      end
    end
  end
end
