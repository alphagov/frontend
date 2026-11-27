RSpec.describe Postcodes::Utils do
  describe ".normalise" do
    it "converts a postcode with spaces and mixed case into a standard format" do
      expect(described_class.normalise(" SW12 1aa ")).to eq("SW121AA")
    end

    it "cuts out odd characters" do
      expect(described_class.normalise("SW121AA[]")).to eq("SW121AA")
    end
  end
end
