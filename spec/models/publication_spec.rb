RSpec.describe Publication do
  subject(:publication) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("publication", example_name: "publication") }

  it_behaves_like "it can have emphasised organisations", "publication", "publication"
  it_behaves_like "it can have people", "publication", "publication"
  it_behaves_like "it has historical government information", "publication", "political_publication"
  it_behaves_like "it can have single page notifications", "publication", "publication"
  it_behaves_like "it has updates", "publication", "withdrawn_publication"
  it_behaves_like "it has no updates", "publication", "publication"

  describe "#contributors" do
    it "returns a list of organisations followed by people" do
      expect(publication.contributors[0].title).to eq("Environment Agency")
      expect(publication.contributors[0].base_path).to eq("/government/organisations/environment-agency")
      expect(publication.contributors[1].title).to eq("The Rt Hon Sir Eric Pickles MP")
      expect(publication.contributors[1].base_path).to eq("/government/people/eric-pickles")
    end
  end

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

  describe "#national_statistics?" do
    it "returns false" do
      expect(publication.national_statistics?).to be false
    end

    context "when the document_type is national_statistics" do
      let(:content_store_response) { GovukSchemas::Example.find("publication", example_name: "statistics_publication") }

      it "returns true" do
        expect(publication.national_statistics?).to be true
      end
    end
  end
end
