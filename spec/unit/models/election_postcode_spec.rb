RSpec.describe ElectionPostcode, type: :model do
  describe "#present?" do
    it "returns true if sanitised_postcode not blank" do
      subject = ElectionPostcode.new("SW1A 1AA")

      expect(subject.present?).to be true
    end
  end

  describe "#valid?" do
    it "rejects invalid postcodes" do
      subject = ElectionPostcode.new("NOTVALID")

      expect(subject.valid?).to be false
    end

    it "passes valid postcodes" do
      subject = ElectionPostcode.new("E10 8QS")

      expect(subject.valid?).to be true
    end
  end

  describe "#sanitized_postcode" do
    it "converts the postcode into upper case and discards non-alpha characters" do
      subject = ElectionPostcode.new("sW1a++*1aA")

      expect(subject.sanitized_postcode).to eq("SW1A 1AA")
    end
  end

  describe "#postcode_for_api" do
    it "uses the sanitized postcode and strip whitespace" do
      subject = ElectionPostcode.new("SW1A  +  1AA")

      expect(subject.postcode_for_api).to eq("SW1A1AA")
    end
  end

  describe "#errors" do
    it "returns an errors for an empty postcode after validation" do
      subject = ElectionPostcode.new("  +  ")

      expect(subject.error).to eq("invalidPostcodeFormat")
    end

    it "returns an error for invalid postcodes" do
      subject = ElectionPostcode.new("Also invalid")

      expect(subject.error).to eq("invalidPostcodeFormat")
    end
  end
end
