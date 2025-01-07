RSpec.describe Speech do
  let(:content_store_response) { GovukSchemas::Example.find("speech", example_name: "speech") }

  it_behaves_like "it has news image", "speech"
  it_behaves_like "it has historical government information", "speech", "speech"
  it_behaves_like "it has updates", "speech", "speech"

  describe "#related_entities" do
    it "returns the linkable organisations as well as speaker" do
      organisations = content_store_response["links"]["organisations"].first
      expect(described_class.new(content_store_response).speaker).to eq(content_store_response["links"]["speaker"])
      expect(described_class.new(content_store_response).related_entities).to include(organisations)
    end

    it "includes speaker without profile" do
      content_store_response = GovukSchemas::Example.find("speech", example_name: "speech-speaker-without-profile")
      expect(described_class.new(content_store_response).related_entities).to include(content_store_response["details"]["speaker_without_profile"])
    end
  end
end
