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

  describe "#on_or_at" do
    it "returns 'on' if the opening time is 12am" do
      content_item.content_store_response["details"]["opening_date"] = "2016-11-04T00:00:00+00:00"

      expect(presenter.on_or_at).to eq("on")
    end

    it "returns 'at' if the opening time is not 12am" do
      content_item.content_store_response["details"]["opening_date"] = "2016-04-16T13:01:57.000+00:00"

      expect(presenter.on_or_at).to eq("at")
    end
  end

  describe "#opens_closes_or_ran" do
    context "when document type is closed_consultation" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "closed_consultation") }

      it "returns ran_from text" do
        expect(presenter.opens_closes_or_ran).to eq("This consultation ran from")
      end
    end

    context "when document type is consultation_outcome" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "consultation_outcome") }

      it "returns ran_from text" do
        expect(presenter.opens_closes_or_ran).to eq("This consultation ran from")
      end
    end

    context "when document type is open_consultation" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "open_consultation") }

      it "returns closes_at text if document type is open_consultation" do
        expect(presenter.opens_closes_or_ran).to eq("This consultation closes at")
      end
    end

    context "when document type is consultation" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "unopened_consultation") }

      it "returns opens at text if document type is consultation" do
        expect(presenter.opens_closes_or_ran).to eq("This consultation opens at")
      end
    end
  end
end
