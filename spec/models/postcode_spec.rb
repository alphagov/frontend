RSpec.describe Postcode do
  subject(:postcode) { described_class.new(postcode_string) }

  let(:postcode_string) { " sw1a1aa" }

  describe "<initialisation>" do
    context "when the postcode is empty" do
      let(:postcode_string) { nil }

      it "raises an InvalidPostcodeError" do
        expect { postcode }.to raise_error(Postcode::InvalidPostcodeError)
      end
    end

    context "when the postcode is incomplete" do
      let(:postcode_string) { "SW1A" }

      it "raises an InvalidPostcodeError" do
        expect { postcode }.to raise_error(Postcode::InvalidPostcodeError)
      end
    end

    context "when the postcode is invalid" do
      let(:postcode_string) { "BADPOSTCODE" }

      it "raises an InvalidPostcodeError" do
        expect { postcode }.to raise_error(Postcode::InvalidPostcodeError)
      end
    end
  end

  describe "#to_s" do
    it "returns the postcode in a display-ready form" do
      expect(postcode.to_s).to eq("SW1A 1AA")
    end

    context "when the postcode entered has I/1 + O/0 mixups" do
      let(:postcode_string) { "BIOOJP" }

      it "returns the postcode in the correct form" do
        expect(postcode.to_s).to eq("B10 0JP")
      end
    end
  end

  describe "#compressed" do
    it "returns the postcode in a compressed form" do
      expect(postcode.compressed).to eq("SW1A1AA")
    end
  end
end
