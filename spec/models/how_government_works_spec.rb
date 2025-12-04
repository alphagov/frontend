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

  describe "#department_counts" do
    it "returns the counts hash from the content item" do
      expect(how_government_works.department_counts).to eq({ "agencies_and_public_bodies" => 1, "ministerial_departments" => 6, "non_ministerial_departments" => 1 })
    end
  end

  describe "#lead_paragraph" do
    it "returns the localisation key" do
      expect(how_government_works.lead_paragraph).not_to be_blank
    end
  end

  describe "#ministerial_role_counts" do
    it "returns the counts hash from the content item" do
      expect(how_government_works.ministerial_role_counts).to eq({ "cabinet_ministers" => 2, "other_ministers" => 3, "prime_minister" => 1, "total_ministers" => 6 })
    end
  end

  describe "#reshuffle_in_progress?" do
    it "returns false" do
      expect(how_government_works.reshuffle_in_progress?).to be false
    end

    context "when a reshuffle is in progress isn't a prime minister" do
      let(:content_item) { GovukSchemas::Example.find("how_government_works", example_name: "reshuffle-mode-on") }

      it "returns true" do
        expect(how_government_works.reshuffle_in_progress?).to be true
      end
    end
  end
end
