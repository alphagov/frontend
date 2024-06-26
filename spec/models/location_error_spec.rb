RSpec.describe LocationError do
  # TODO: this test looks odd because it's testing for localisation keys,
  # not the values of them. This is because LocationError is a bit odd,
  # and it might be worth refactoring the actual code after the RSpec
  # conversion is finished.
  describe "#initialize" do
    context "when given a postcode error with a message and sub message" do
      it "sets the message and the sub message" do
        error = described_class.new("fullPostcodeNoLocationsApiMatch")

        expect(error.message).to eq("formats.local_transaction.valid_postcode_no_match")
        expect(error.sub_message).to eq("formats.local_transaction.valid_postcode_no_match_sub_html")
      end
    end

    context "when given a postcode error with a message and no sub message" do
      it "sets the message and an empty string sub message" do
        error = described_class.new("noLaMatch")

        expect(error.message).to eq("formats.local_transaction.no_local_authority")
        expect(error.sub_message).to eq("")
      end
    end

    context "when given a postcode error without a message" do
      it "sets default message and sub message" do
        error = described_class.new("some_error")

        expect(error.message).to eq("formats.local_transaction.invalid_postcode")
        expect(error.sub_message).to eq("formats.local_transaction.invalid_postcode_sub")
      end
    end
  end
end
