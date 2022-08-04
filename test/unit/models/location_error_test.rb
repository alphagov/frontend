class LocationErrorTest < ActiveSupport::TestCase
  context "#initialize" do
    context "when given a postcode error with a message and sub message" do
      should "set the message and the sub message" do
        error = LocationError.new("fullPostcodeNoLocationsApiMatch")
        assert_equal(error.message, "formats.local_transaction.valid_postcode_no_match")
        assert_equal(error.sub_message, "formats.local_transaction.valid_postcode_no_match_sub_html")
      end
    end

    context "when given a postcode error with a message and no sub message" do
      should "set the message and an empty string sub message" do
        error = LocationError.new("noLaMatch")
        assert_equal(error.message, "formats.local_transaction.no_local_authority")
        assert_equal(error.sub_message, "")
      end
    end

    context "when given a postcode error without a message" do
      should "set default message and sub message" do
        error = LocationError.new("some_error")
        assert_equal(error.message, "formats.local_transaction.invalid_postcode")
        assert_equal(error.sub_message, "formats.local_transaction.invalid_postcode_sub")
      end
    end
  end
end
