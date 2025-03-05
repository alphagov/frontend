RSpec.describe SpeechPresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_item) { Speech.new(content_store_response) }

  describe "#speech_contributor_links" do
    context "when the speaker has a profile" do
      let(:content_store_response) { GovukSchemas::Example.find("speech", example_name: "speech") }

      it "returns the organisation and the speaker" do
        expected_contributors =
          [{ text: "Department of Energy & Climate Change", path: "/government/organisations/department-of-energy-climate-change" },
           { text: "The Rt Hon Andrea Leadsom MP", path: "/government/people/andrea-leadsom" }]
        expect(presenter.speech_contributor_links).to eq(expected_contributors)
      end
    end

    context "when the speaker does not have a profile" do
      let(:content_store_response) { GovukSchemas::Example.find("speech", example_name: "speech-speaker-without-profile") }

      it "returns the organisation and the speaker without a profile" do
        expected_contributors =
          [{ text: "Prime Minister's Office, 10 Downing Street", path: "/government/organisations/prime-ministers-office-10-downing-street" },
           { text: "Cabinet Office", path: "/government/organisations/cabinet-office" },
           { text: "Her Majesty the Queen" }]
        expect(presenter.speech_contributor_links).to eq(expected_contributors)
      end
    end
  end

  describe "#delivery_type" do
    context "when presented speech is Written Statement" do
      let(:content_store_response) { GovukSchemas::Example.find("speech", example_name: "speech-written-statement-parliament") }

      it "presents the speech as being delivered" do
        expect(presenter.delivery_type).to eq("Delivered on")
      end
    end

    context "when presented speech is an authored article" do
      let(:content_store_response) { GovukSchemas::Example.find("speech", example_name: "speech-authored-article") }

      it "presents the speech as being written" do
        expect(presenter.delivery_type).to eq("Written on")
      end
    end
  end
end
