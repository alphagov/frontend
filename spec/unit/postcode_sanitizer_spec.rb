RSpec.describe PostcodeSanitizer do
  context "postcodes are sanitized before being sent to LocationsApi" do
    it "strips trailing spaces from entered postcodes" do
      expect(PostcodeSanitizer.sanitize("WC2B 6NH ")).to eq("WC2B 6NH")
    end

    it "strips non-alphanumerics from entered postcodes" do
      expect(PostcodeSanitizer.sanitize("WC2B   -6NH]")).to eq("WC2B 6NH")
    end

    it "transposes O/0 and I/1 if necessary" do
      expect(PostcodeSanitizer.sanitize("WIA OAA")).to eq("W1A 0AA")
    end
  end

  context "if the postcode parameter is nil or an empty string" do
    it "returns nil and does not try to perform sanitization" do
      expect(PostcodeSanitizer.sanitize("")).to be_nil
    end
  end
end
