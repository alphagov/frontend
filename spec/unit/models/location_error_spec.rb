RSpec.describe LocationError, type: :model do
  describe "#initialize" do
    context "when given a postcode error with a message and sub message" do
      it "sets the message and the sub message" do
        error = LocationError.new("fullPostcodeNoLocationsApiMatch")

        expect("formats.local_transaction.valid_postcode_no_match").to eq(error.message)
        expect("formats.local_transaction.valid_postcode_no_match_sub_html").to eq(error.sub_message)
      end
    end

    context "when given a postcode error with a message and no sub message" do
      it "sets the message and an empty string sub message" do
        error = LocationError.new("noLaMatch")

        expect("formats.local_transaction.no_local_authority").to eq(error.message)
        expect("").to eq(error.sub_message)
      end
    end

    context "when given a postcode error without a message" do
      it "sets default message and sub message" do
        error = LocationError.new("some_error")

        expect("formats.local_transaction.invalid_postcode").to eq(error.message)
        expect("formats.local_transaction.invalid_postcode_sub").to eq(error.sub_message)
      end
    end
  end
end
