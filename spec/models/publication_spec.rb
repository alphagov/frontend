RSpec.describe Publication do
  subject(:publication) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("publication", example_name: "publication") }

  describe "#dataset?" do
    it "returns false" do
      expect(publication.dataset?).to be false
    end

    context "when the document_type is in the datasets list" do
      let(:content_store_response) { GovukSchemas::Example.find("publication", example_name: "best-practice-official-statistics") }

      it "returns true" do
        expect(publication.dataset?).to be true
      end
    end
  end
end
