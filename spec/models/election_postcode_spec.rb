RSpec.describe ElectionPostcode do
  describe "#present?" do
    it "returns true if sanitised_postcode not blank" do
      subject = described_class.new("SW1A 1AA")

      expect(subject.present?).to be true
    end
  end

  describe "#valid?" do
    it "rejects invalid postcodes" do
      subject = described_class.new("NOTVALID")

      expect(subject.valid?).to be false
    end

    it "passes valid postcodes" do
      subject = described_class.new("E10 8QS")

      expect(subject.valid?).to be true
    end
  end

  describe "#sanitized_postcode" do
    it "converts the postcode into upper case and discards non-alpha characters" do
      subject = described_class.new("sW1a++*1aA")

      expect(subject.sanitized_postcode).to eq("SW1A 1AA")
    end
  end

  describe "#postcode_for_api" do
    it "uses the sanitized postcode and strip whitespace" do
      subject = described_class.new("SW1A  +  1AA")

      expect(subject.postcode_for_api).to eq("SW1A1AA")
    end
  end

  describe "#errors" do
    it "returns an errors for an empty postcode after validation" do
      subject = described_class.new("  +  ")

      expect(subject.error).to eq("invalidPostcodeFormat")
    end

    it "returns an error for invalid postcodes" do
      subject = described_class.new("Also invalid")

      expect(subject.error).to eq("invalidPostcodeFormat")
    end
  end
end
