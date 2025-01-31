RSpec.describe SpeechPresenter do
  subject(:presenter) { described_class.new(content_item, ApplicationController.new.view_context) }

  let(:content_item) { Speech.new(content_store_response) }

  context "when the speech includes speaker" do
    let(:content_store_response) { GovukSchemas::Example.find("speech", example_name: "speech") }

    it "presents a speech location" do
      expect(presenter.important_metadata["Location"]).to eq("Women in Nuclear UK Conference, Church House Conference Centre, Dean's Yard, Westminster, London")
    end

    it "sets the delivery type of the speech" do
      expect(presenter.delivery_type).to eq("Delivered on")
    end

    it "presents a delivered on date with speech type explanation for the metadata component" do
      expect(presenter.delivered_on_metadata).to eq('<time datetime="2016-02-02T00:00:00+00:00">2 February 2016</time> (Original script, may differ from delivered version)')
    end
  end

  context "when presented speech is Written Statement" do
    let(:content_store_response) { GovukSchemas::Example.find("speech", example_name: "speech-written-statement-parliament") }

    it "presents the speech as being delivered" do
      expect(presenter.delivery_type).to eq("Delivered on")
    end

    it "presents a delivered on date without an explanation" do
      expect(presenter.delivered_on_metadata).to eq('<time datetime="2016-12-20T15:00:00+00:00">20 December 2016</time>')
    end
  end

  context "when presented speech is an authored article" do
    let(:content_store_response) { GovukSchemas::Example.find("speech", example_name: "speech-authored-article") }

    it "presents the speech as being written" do
      expect(presenter.delivery_type).to eq("Written on")
    end

    it "presents a delivered on date without an explanation" do
      expect(presenter.delivered_on_metadata).to eq('<time datetime="2016-04-05T00:00:00+01:00">5 April 2016</time>')
    end
  end
end
