RSpec.describe Uprn, type: :model do
  describe "#valid?" do
    it "fails uprns with non-numerical characters" do
      subject = Uprn.new("1234-34")
      expect(subject.valid?).to be false
    end
    it "fails uprns that are too long" do
      subject = Uprn.new("12345678910110")
      expect(subject.valid?).to be false
    end

    it "passes valid uprns - some digits" do
      subject = Uprn.new("12345")
      expect(subject.valid?).to be true
    end

    it "passes valid uprns - 12 digits" do
      subject = Uprn.new("012345678910")
      expect(subject.valid?).to be true
    end

    it "passes valid uprns - ignoring whitespace" do
      subject = Uprn.new(" 012345678910 ")
      expect(subject.valid?).to be true
    end
  end

  describe "#uprn" do
    it "trims surrounding whitespace" do
      subject = Uprn.new(" 123456789 ")
      expect(subject.sanitized_uprn).to eq("123456789")
    end
  end

  describe "#errors" do
    it "detects empty uprn as invalid" do
      subject = Uprn.new("    ")
      expect(subject.error).to eq("invalidUprnFormat")
    end

    it "detects invalid uprn" do
      subject = Uprn.new("Also invalid")
      expect(subject.error).to eq("invalidUprnFormat")
    end
  end
end
