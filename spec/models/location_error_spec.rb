RSpec.describe LocationError do
  # TODO: this test looks odd because it's testing for localisation keys,
  # not the values of them. This is because LocationError is a bit odd,
  # and it might be worth refactoring the actual code after the RSpec
  # conversion is finished.

  subject(:location_error) { described_class.new(postcode_error) }

  describe "#initialize" do
    let(:postcode_error) { "fullPostcodeNoLocationsApiMatch" }

    context "when given a postcode error with a message and sub message" do
      it "sets the message and the sub message" do
        expect(location_error.message).to eq("formats.local_transaction.valid_postcode_no_match")
        expect(location_error.sub_message).to eq("formats.local_transaction.valid_postcode_no_match_sub_html")
      end
    end

    context "when given a postcode error with a message and no sub message" do
      let(:postcode_error) { "noLaMatch" }

      it "sets the message and an empty string sub message" do
        expect(location_error.message).to eq("formats.local_transaction.no_local_authority")
        expect(location_error.sub_message).to eq("")
      end
    end

    context "when given a postcode error without a message" do
      let(:postcode_error) { "some_error" }

      it "sets default message and sub message" do
        expect(location_error.message).to eq("formats.local_transaction.invalid_postcode")
        expect(location_error.sub_message).to eq("formats.local_transaction.invalid_postcode_sub")
      end
    end

    context "when given electoralServiceNotAvailable postcode error" do
      let(:postcode_error) { "electoralServiceNotAvailable" }

      it "sets the message and no submessage" do
        expect(location_error.message).to eq("formats.local_transaction.electoral_service_not_available")
        expect(location_error.sub_message).to eq("")
      end
    end
  end
end
