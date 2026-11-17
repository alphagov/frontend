RSpec.describe LocationError do
  # TODO: this test looks odd because it's testing for localisation keys,
  # not the values of them. This is because LocationError is a bit odd,
  # and it might be worth refactoring the actual code after the RSpec
  # conversion is finished.

  subject(:location_error) { described_class.new(postcode_error) }

  describe "#initialize" do
    let(:postcode_error) { "fullPostcodeNoLocationsApiMatch" }

    context "when given a postcode error with a message" do
      it "sets the message" do
        expect(location_error.message).to eq("formats.local_transaction.valid_postcode_no_match")
      end
    end

    context "when given a postcode error without a message" do
      let(:postcode_error) { "some_error" }

      it "sets default message" do
        expect(location_error.message).to eq("formats.local_transaction.invalid_postcode")
      end
    end

    context "when given electoralServiceNotAvailable postcode error" do
      let(:postcode_error) { "electoralServiceNotAvailable" }

      it "sets the message" do
        expect(location_error.message).to eq("formats.local_transaction.electoral_service_not_available")
      end
    end
  end

  describe "#data_related?" do
    context "when error is related to the entered postcode" do
      let(:postcode_error) { "invalidPostcodeFormat" }

      it "returns true" do
        expect(location_error.data_related?).to be(true)
      end
    end

    context "when error is related to the service itself and not the entered postcode" do
      let(:postcode_error) { "electoralServiceNotAvailable" }

      it "returns false" do
        expect(location_error.data_related?).to be(false)
      end
    end
  end
end
