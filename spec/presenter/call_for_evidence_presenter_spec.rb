RSpec.describe CallForEvidencePresenter do
  let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "open_call_for_evidence") }
  let(:content_item) { CallForEvidence.new(content_store_response) }
  let(:presenter) { described_class.new(content_item) }

  describe "#opening_date_time" do
    it "returns the opening date and time" do
      expect(presenter.opening_date_time).to eq("2023-04-11T13:01:57.000+00:00")
    end
  end

  describe "#opening_date" do
    it "presents a friendly opening date and time" do
      expect(presenter.opening_date).to eq("2:01pm on 11 April 2023")
    end

    it "presents an opening date without a time if the time is 12am" do
      content_item.content_store_response["details"]["opening_date"] = "2016-11-03T00:00:00+00:00"
      expect(presenter.opening_date).to eq("3 November 2016")
    end

    it "presents 12pm as midday" do
      content_item.content_store_response["details"]["opening_date"] = "2016-11-04T12:00:00+00:00"
      expect(presenter.opening_date).to eq("midday on 4 November 2016")
    end
  end

  describe "#closing_date_time" do
    it "returns the closing date and time" do
      expect(presenter.closing_date_time).to eq("2231-04-16T13:01:57.000+00:00")
    end
  end

  describe "#closing_date" do
    it "presents a friendly closing date and time" do
      expect(presenter.closing_date).to eq("1:01pm on 16 April 2231")
    end

    it "presents a closing date and time as 11:59am on the day before if the time is 12am" do
      content_item.content_store_response["details"]["closing_date"] = "2016-11-04T00:00:00+00:00"
      expect(presenter.closing_date).to eq("11:59pm on 3 November 2016")
    end
  end

  describe "#opening_date_midnight?" do
    it "returns true if the opening time is 12am" do
      content_item.content_store_response["details"]["opening_date"] = "2016-11-04T00:00:00+00:00"
      expect(presenter.opening_date_midnight?).to be(true)
    end

    it "returns false if the opening time is not 12am" do
      content_item.content_store_response["details"]["opening_date"] = "2016-04-16T13:01:57.000+00:00"
      expect(presenter.opening_date_midnight?).to be(false)
    end
  end
end
