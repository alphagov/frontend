class LocationErrorTest < ActiveSupport::TestCase
  context "#initialize" do
    should "default to default message when no message given" do
      error = LocationError.new("some_error")
      assert_equal(error.message, "formats.local_transaction.invalid_postcode")
    end

    context "when given a postcode_error" do
      should "send the postcode error as a notification" do
        ActiveSupport::Notifications.expects(:instrument).with("postcode_error_notification", postcode_error: "some_error")

        LocationError.new("some_error")
      end
    end

    context "when not given a postcode_error" do
      should "not send a postcode_error notification" do
        ActiveSupport::Notifications.expects(:instrument).never

        LocationError.new
      end
    end

    context "when given a valid postcode with no location found" do
      should "send no location found error" do
        error = LocationError.new("validPostcodeNoLocation")
        assert_equal(error.message, "formats.find_my_nearest.valid_postcode_no_locations")
      end
    end
  end
end
