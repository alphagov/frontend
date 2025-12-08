RSpec.describe HowGovernmentWorksPresenter do
  subject(:how_government_works_presenter) { described_class.new(content_item) }

  let(:content_item) { HowGovernmentWorks.new(content_store_response) }

  describe "#agencies_and_other_public_bodies" do
    let(:content_store_response) do
      GovukSchemas::Example.find("how_government_works", example_name: "reshuffle-mode-off").tap do |item|
        item["details"]["department_counts"]["agencies_and_public_bodies"] = "432"
      end
    end

    it "returns the figure truncated with a plus sign" do
      expect(how_government_works_presenter.agencies_and_other_public_bodies).to eq("400+")
    end
  end
end
