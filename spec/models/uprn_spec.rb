RSpec.describe Uprn do
  subject(:uprn) { described_class.new(uprn_string) }

  let(:uprn_string) { " 012345678910 " }

  describe "<initialisation>" do
    context "when the uprn is empty" do
      let(:uprn_string) { nil }

      it "raises an InvalidUprnError" do
        expect { uprn }.to raise_error(Uprn::InvalidUprnError)
      end
    end

    context "when the uprn is too long" do
      let(:uprn_string) { "12345678910110" }

      it "raises an InvalidUprnError" do
        expect { uprn }.to raise_error(Uprn::InvalidUprnError)
      end
    end

    context "when the uprn is invalid" do
      let(:uprn_string) { "1234-5678" }

      it "raises an InvalidUprnError" do
        expect { uprn }.to raise_error(Uprn::InvalidUprnError)
      end
    end
  end

  describe "#to_s" do
    it "returns the uprn trimmed" do
      expect(uprn.to_s).to eq("012345678910")
    end
  end
end
