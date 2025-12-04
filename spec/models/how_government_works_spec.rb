RSpec.describe HowGovernmentWorks do
  subject(:how_government_works) { described_class.new(content_item) }

  let(:content_item) { GovukSchemas::Example.find("how_government_works", example_name: "reshuffle-mode-off") }

  describe "#lead_paragraph" do
    it "returns the localisation key" do
      expect(how_government_works.lead_paragraph).not_to be_blank
    end
  end
end
