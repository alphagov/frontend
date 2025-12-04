RSpec.describe HowGovernmentWorks do
  subject(:how_government_works) { described_class.new(content_item) }

  let(:content_item) { GovukSchemas::Example.find("how_government_works", example_name: "reshuffle-mode-off") }

  describe "#current_prime_minister" do
    it "returns the current prime minister object key" do
      expect(how_government_works.current_prime_minister).not_to be_nil
      expect(how_government_works.current_prime_minister.title).to eq("The Rt Hon Rishi Sunak MP")
    end

    context "when there isn't a prime minister" do
      let(:content_item) do
        GovukSchemas::Example.find("how_government_works", example_name: "reshuffle-mode-off").tap do |item|
          item["links"].delete("current_prime_minister")
        end
      end

      it "returns the prime minister object key" do
        expect(how_government_works.current_prime_minister).to be_nil
      end
    end
  end

  describe "#lead_paragraph" do
    it "returns the localisation key" do
      expect(how_government_works.lead_paragraph).not_to be_blank
    end
  end
end
