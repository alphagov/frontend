RSpec.describe History do
  subject(:history) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("history", example_name: "history") }

  it_behaves_like "it can have images", "history", "history", "sidebar"

  describe "#lead_paragraph" do
    it "returns the lead paragraph from the details" do
      expect(history.lead_paragraph).to be_nil
    end

    context "when a lead_paragraph is present" do
      let(:content_store_response) { GovukSchemas::Example.find("history", example_name: "history_homepage") }

      it "returns the lead paragraph from the details" do
        expect(history.lead_paragraph).to eq(content_store_response["details"]["lead_paragraph"])
      end
    end
  end
end
