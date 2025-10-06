RSpec.describe Speech do
  subject(:content_item) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("speech", example_name: "speech") }

  it_behaves_like "it has news image", "speech", "speech"
  it_behaves_like "it has historical government information", "speech", "speech"
  it_behaves_like "it has updates", "speech", "speech-with-updates"
  it_behaves_like "it has no updates", "speech", "speech"
  it_behaves_like "it can be withdrawn", "speech", "withdrawn-speech"

  describe "#contributors" do
    context "when emphasised organisation is present" do
      it "returns the emphasised organisation first" do
        content_store_response = GovukSchemas::Example.find("speech", example_name: "speech-written-statement-parliament")
        content_item = described_class.new(content_store_response)

        organisations = content_store_response["links"]["organisations"]
        expect(content_item.contributors[0].title).to eq(organisations[0]["title"])
        expect(content_item.contributors[1].title).to eq(organisations[1]["title"])
      end
    end

    context "when people and speaker are present" do
      it "returns the organisations followed by speaker" do
        organisations = content_store_response.dig("links", "organisations")
        speaker = content_store_response.dig("links", "speaker")

        expect(content_item.contributors.count).to eq(2)
        expect(content_item.contributors[0].title).to eq(organisations[0]["title"])
        expect(content_item.contributors[1].title).to eq(speaker[0]["title"])
      end
    end

    context "when people is not present" do
      it "returns the organisations followed by speaker" do
        content_store_response = GovukSchemas::Example.find("speech", example_name: "speech-authored-article")
        content_item = described_class.new(content_store_response)

        organisations = content_store_response.dig("links", "organisations")
        speaker = content_store_response.dig("links", "speaker")

        expect(content_item.contributors.count).to eq(2)
        expect(content_item.contributors[0].title).to eq(organisations[0]["title"])
        expect(content_item.contributors[1].title).to eq(speaker[0]["title"])
      end
    end
  end

  describe "#speaker" do
    it "returns title and base path for speaker with profile" do
      speaker = content_store_response.dig("links", "speaker")
      expect(content_item.speaker[0].title).to eq(speaker[0]["title"])
      expect(content_item.speaker[0].base_path).to eq(speaker[0]["base_path"])
    end
  end

  describe "#speaker_without_profile" do
    it "returns speaker without profile" do
      content_store_response = GovukSchemas::Example.find("speech", example_name: "speech-speaker-without-profile")
      content_item = described_class.new(content_store_response)
      expect(content_item.speaker_without_profile).to eq(content_store_response["details"]["speaker_without_profile"])
    end
  end

  describe "#location" do
    it "returns location for important-metadata" do
      expect(content_item.location).to eq(content_store_response["details"]["location"])
    end
  end

  describe "#delivered_on_date" do
    it "returns delivered on date for important-metadata" do
      expect(content_item.delivered_on_date).to eq(content_store_response["details"]["delivered_on"])
    end
  end

  describe "#speech_type_explanation" do
    it "returns speech type explanation for important-metadata" do
      expect(content_item.speech_type_explanation).to eq(" (#{content_store_response['details']['speech_type_explanation']})")
    end

    it "returns nil when explanation does not exist" do
      content_store_response = GovukSchemas::Example.find("speech", example_name: "speech-written-statement-parliament")
      content_item = described_class.new(content_store_response)

      expect(content_item.speech_type_explanation).to be_nil
    end
  end

  describe "#image" do
    describe "document is a speech with a custom lead image" do
      let(:content_store_response) { GovukSchemas::Example.find("speech", example_name: "speech") }

      it "fetches lead image from the details" do
        expect(content_item.image).to eq(content_store_response.dig("details", "image"))
      end
    end

    describe "document is a speech without a custom lead image" do
      let(:content_store_response) { GovukSchemas::Example.find("speech", example_name: "speech") }

      it "fetches lead image from primary publishing organisation" do
        content_store_response["details"] = content_store_response["details"].delete("image") # drop the custom image so we can test the fallback
        content_store_response["links"]["primary_publishing_organisation"] = [
          { "details" =>
              {
                "default_news_image" => {
                  "high_resolution_url" => "https://assets.publishing.service.gov.uk/media/621e4de4e90e0710be0354d7/s960_fcdo-main-building.jpg",
                  "url" => "https://assets.publishing.service.gov.uk/media/621e4de48fa8f5490aff83b4/s300_fcdo-main-building.jpg",
                },
              } },
        ]
        expect(content_item.image).to eq(content_store_response.dig("links", "primary_publishing_organisation")[0].dig("details", "default_news_image"))
      end
    end

    describe "document is a speech without a custom lead image, and no default news image on the primary organisation" do
      let(:content_store_response) { GovukSchemas::Example.find("speech", example_name: "speech") }

      it "does not fall back to non-primary organisations, but uses the placeholder image" do
        content_store_response["details"] = content_store_response["details"].delete("image") # drop the custom image so we can test the fallback
        content_store_response["links"]["primary_publishing_organisation"] = [{ "details" => { "default_news_image" => nil } }] # drop the default news image so we can test the fallback
        content_store_response["links"]["organisations"] = [
          { "details" =>
              {
                "default_news_image" => {
                  "high_resolution_url" => "https://assets.publishing.service.gov.uk/media/621e4de4e90e0710be0354d7/s960_fcdo-main-building.jpg",
                  "url" => "https://assets.publishing.service.gov.uk/media/621e4de48fa8f5490aff83b4/s300_fcdo-main-building.jpg",
                },
              } },
        ] # mock default news image on secondary organisation
        expect(content_item.image).to include({ "url" => "https://assets.publishing.service.gov.uk/media/5e59279b86650c53b2cefbfe/placeholder.jpg" })
      end
    end
  end
end
