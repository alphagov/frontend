require 'test_helper'

class LocationErrorTest < ActiveSupport::TestCase
  context '#initialize' do
    setup do
      @track_id = 'UA-26179049-7'
      @client_id = '3405c765-e24b-48fa-aa90-b9529b31a6eb'
    end

    should 'default to default message when no message given' do
      error = LocationError.new(postcode_error = 'some_error')
      assert_equal(error.message, 'formats.local_transaction.invalid_postcode')
    end

    context 'when given a postcode_error' do
      should 'send the postcode error as a notification' do
        ActiveSupport::Notifications.expects(:instrument).with('postcode_error_notification', postcode_error: "some_error")

        error = LocationError.new(postcode_error = 'some_error')
      end

      should 'create a new GA event' do
        @tracker = Staccato.tracker(@track_id, @client_id, ssl: true)
        @event = Staccato::Event.new(@tracker, {})

        Staccato::Event.stubs(:new).returns(@event)
        @event.stubs(:track!)
        @event.expects(:track!)

        error = LocationError.new(postcode_error = 'some_error')
      end
    end

    context 'when not given a postcode_error' do
      should 'not send a postcode_error notification' do
        ActiveSupport::Notifications.expects(:instrument).never

        error = LocationError.new
      end
    end

    context 'when given a valid postcode with no location found' do
      should 'send no location found error' do
        error = LocationError.new('validPostcodeNoLocation')
        assert_equal(error.message, 'formats.find_my_nearest.valid_postcode_no_locations')
      end
    end
  end
end
