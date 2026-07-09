RSpec.describe History do
  subject(:history) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("history", example_name: "history") }

  it_behaves_like "it can have images", "history", "history", "sidebar"

  describe "#contents_outline" do
    it "makes a content outline object from details/headers" do
      expect(history.contents_outline).to be_instance_of(ContentsOutline)
      expect(history.contents_outline.items.count).to eq(2)
      expect(history.contents_outline.items.first.text).to eq("Introduction – by Sir Anthony Seldon")
      expect(history.contents_outline.items.first.id).to eq("introduction-by-sir-anthony-seldon")
    end
  end

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
