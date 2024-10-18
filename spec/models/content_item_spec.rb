RSpec.describe ContentItem do
  describe "#is_a_xxxx?" do
    let(:subject) { described_class.new({ "schema" => "landing_page" }) }

    it "returns true when called with the schema of the object" do
      expect(subject.is_a_landing_page?).to be true
    end

    it "returns false when called with a mismatching schema" do
      expect(subject.is_a_place?).to be false
    end

    it "also handles is_an_xxxx?" do
      expect(subject.is_an_organisation?).to be false
    end

    it "still passes other missing methods to parent" do
      expect { subject.was_a_landing_page? }.to raise_error(NoMethodError)
    end

    it "responds to the various methods" do
      expect(subject.respond_to?(:is_a_landing_page?)).to be true
      expect(subject.respond_to?(:is_an_organisation?)).to be true
      expect(subject.respond_to?(:was_a_landing_page?)).to be false
    end
  end
end
