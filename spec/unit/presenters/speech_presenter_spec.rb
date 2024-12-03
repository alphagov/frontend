RSpec.describe Speech do
  context "when the speech includes speaker" do
    content_store_response = GovukSchemas::Example.find("speech", example_name: "speech")
    content_item = described_class.new(content_store_response)
    presenter = SpeechPresenter.new(content_item)

    it "presents a speech location" do
      expect(presenter.important_metadata["Location"]).to eq("Women in Nuclear UK Conference, Church House Conference Centre, Dean's Yard, Westminster, London")
    end

    it "from includes speaker" do
      expect(presenter.from).to include("<a class=\"govuk-link\" href=\"/government/people/andrea-leadsom\">The Rt Hon Andrea Leadsom MP</a>")
    end

    it "sets the delivery type of the speech" do
      expect(presenter.delivery_type).to eq("Delivered on")
    end

    it "presents a delivered on date with speech type explanation for the metadata component" do
      expect(presenter.delivered_on_metadata).to eq('<time datetime="2016-02-02T00:00:00+00:00">2 February 2016</time> (Original script, may differ from delivered version)')
    end
  end

  context "when presented speech is Written Statement" do
    content_store_response = GovukSchemas::Example.find("speech", example_name: "speech-written-statement-parliament")
    content_item = described_class.new(content_store_response)
    presenter = SpeechPresenter.new(content_item)

    it "presents the speech as being delivered" do
      expect(presenter.delivery_type).to eq("Delivered on")
    end

    it "presents a delivered on date without an explanation" do
      expect(presenter.delivered_on_metadata).to eq('<time datetime="2016-12-20T15:00:00+00:00">20 December 2016</time>')
    end
  end

  context "when presented speech is an authored article" do
    content_store_response = GovukSchemas::Example.find("speech", example_name: "speech-authored-article")
    content_item = described_class.new(content_store_response)
    presenter = SpeechPresenter.new(content_item)

    it "presents the speech as being written" do
      expect(presenter.delivery_type).to eq("Written on")
    end

    it "presents a delivered on date without an explanation" do
      expect(presenter.delivered_on_metadata).to eq('<time datetime="2016-04-05T00:00:00+01:00">5 April 2016</time>')
    end
  end

  context "when speaker is without profile" do
    content_store_response = GovukSchemas::Example.find("speech", example_name: "speech-speaker-without-profile")
    content_item = described_class.new(content_store_response)
    presenter = SpeechPresenter.new(content_item)

    it "includes speaker without profile in from_with_speaker" do
      expect(presenter.from).to eq("Her Majesty the Queen")
    end
  end
end
