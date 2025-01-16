RSpec.describe Speech do
  let(:content_store_response) { GovukSchemas::Example.find("speech", example_name: "speech") }

  it_behaves_like "it has news image", "speech"
  it_behaves_like "it has updates", "speech", "speech-with-updates"
  it_behaves_like "it has no updates", "speech", "speech"
  it_behaves_like "it can be withdrawn", "speech", "withdrawn-speech"

  describe "#contributors" do
    it "returns the organisations as well as speaker" do
      organisations = content_store_response["links"]["organisations"]
      expect(described_class.new(content_store_response).speaker).to eq(content_store_response["links"]["speaker"])
      expected_contributors =
        { "title" => organisations[0]["title"], "base_path" => organisations[0]["base_path"], "content_id" => organisations[0]["content_id"] }

      expect(described_class.new(content_store_response).contributors).to include(expected_contributors)
    end

    it "returns speaker without profile" do
      content_store_response = GovukSchemas::Example.find("speech", example_name: "speech-speaker-without-profile")
      expect(described_class.new(content_store_response).contributors).to include(content_store_response["details"]["speaker_without_profile"])
    end
  end

  describe "#location" do
    it "returns location for important-metadata" do
      expect(described_class.new(content_store_response).location).to eq(content_store_response["details"]["location"])
    end
  end

  describe "#delivered_on_date" do
    it "returns delivered on date for important-metadata" do
      expect(described_class.new(content_store_response).delivered_on_date).to eq(content_store_response["details"]["delivered_on"])
    end
  end

  describe "#speech_type_explanation" do
    it "returns speech type explanation for important-metadata" do
      expect(described_class.new(content_store_response).speech_type_explanation).to eq(" (#{content_store_response['details']['speech_type_explanation']})")
    end

    it "returns nil when explanation does not exist" do
      content_store_response = GovukSchemas::Example.find("speech", example_name: "speech-written-statement-parliament")
      expect(described_class.new(content_store_response).speech_type_explanation).to be_nil
    end
  end
end
