RSpec.describe SpeechPresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_item) { Speech.new(content_store_response) }

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
