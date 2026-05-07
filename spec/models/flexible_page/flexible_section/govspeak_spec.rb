RSpec.describe FlexiblePage::FlexibleSection::Govspeak do
  subject(:govspeak) { described_class.new(govspeak: govspeak_val) }

  let(:govspeak_val) { "<h3>Header</h3><p>Hello</p>" }

  describe "#initialize" do
    it "sets the attributes from the parameters" do
      expect(govspeak.govspeak).to eq(govspeak_val)
    end
  end
end
