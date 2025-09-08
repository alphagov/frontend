RSpec.describe ConsultationPresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "open_consultation") }
  let(:content_item) { Consultation.new(content_store_response) }

  describe "#opening_date" do
    it "presents a friendly opening date and time" do
      content_item.content_store_response["details"]["opening_date"] = "2016-11-04T10:00:00+00:00"

      expect(presenter.opening_date).to eq("10am on 4 November 2016")
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

  describe "#closing_date" do
    it "presents a friendly closing date and time" do
      content_item.content_store_response["details"]["closing_date"] = "2016-12-16T16:00:00+00:00"

      expect(presenter.closing_date).to eq("4pm on 16 December 2016")
    end

    it "presents a closing date and time as 11:59am on the day before if the time is 12am" do
      content_item.content_store_response["details"]["closing_date"] = "2016-11-04T00:00:00+00:00"

      expect(presenter.closing_date).to eq("11:59pm on 3 November 2016")
    end
  end
end
