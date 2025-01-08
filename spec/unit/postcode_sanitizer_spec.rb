RSpec.describe PostcodeSanitizer do
  describe "#sanitize" do
    it "strips trailing spaces from entered postcodes" do
      expect(described_class.sanitize("WC2B 6NH ")).to eq("WC2B 6NH")
    end

    it "strips non-alphanumerics from entered postcodes" do
      expect(described_class.sanitize("WC2B   -6NH]")).to eq("WC2B 6NH")
    end

    it "transposes O/0 and I/1 if necessary" do
      expect(described_class.sanitize("WIA OAA")).to eq("W1A 0AA")
    end

    context "when the postcode parameter is nil or an empty string" do
      it "returns nil and does not try to perform sanitization" do
        expect(described_class.sanitize("")).to be_nil
      end
    end
  end
end
