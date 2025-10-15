RSpec.describe ConsultationHelper do
  describe "#opening_date" do
    it "presents a friendly opening date and time" do
      opening_date_time = "2016-11-04T10:00:00+00:00"

      expect(opening_date(opening_date_time)).to eq("10am on 4 November 2016")
    end

    it "presents an opening date without a time if the time is 12am" do
      opening_date_time = "2016-11-03T00:00:00+00:00"

      expect(opening_date(opening_date_time)).to eq("3 November 2016")
    end

    it "presents 12pm as midday" do
      opening_date_time = "2016-11-04T12:00:00+00:00"

      expect(opening_date(opening_date_time)).to eq("midday on 4 November 2016")
    end
  end

  describe "#closing_date" do
    it "presents a friendly closing date and time" do
      closing_date_time = "2016-12-16T16:00:00+00:00"

      expect(closing_date(closing_date_time)).to eq("4pm on 16 December 2016")
    end

    it "presents a closing date and time as 11:59am on the day before if the time is 12am" do
      closing_date_time = "2016-11-04T00:00:00+00:00"

      expect(closing_date(closing_date_time)).to eq("11:59pm on 3 November 2016")
    end
  end

  describe "#on_or_at" do
    it "returns 'on' if the opening time is 12am" do
      opening_date_time = "2016-11-04T00:00:00+00:00"

      expect(on_or_at(opening_date_time)).to eq("on")
    end

    it "returns 'at' if the opening time is not 12am" do
      opening_date_time = "2016-04-16T13:01:57.000+00:00"

      expect(on_or_at(opening_date_time)).to eq("at")
    end
  end

  describe "#opens_closes_or_ran" do
    context "when schema_name is 'consultation'" do
      it "returns ran_from text when document type is closed_consultation" do
        expect(opens_closes_or_ran("closed_consultation", "consultation")).to eq("This consultation ran from")
      end

      it "returns ran_from text when document type is consultation_outcome" do
        expect(opens_closes_or_ran("consultation_outcome", "consultation")).to eq("This consultation ran from")
      end

      it "returns closes_at text when document type is open_consultation" do
        expect(opens_closes_or_ran("open_consultation", "consultation")).to eq("This consultation closes at")
      end

      it "returns opens at text when document type is consultation" do
        expect(opens_closes_or_ran("consultation", "consultation")).to eq("This consultation opens at")
      end
    end

    context "when schema_name is 'call_for_evidence'" do
      it "returns ran_from text when document type is closed_call_for_evidence" do
        expect(opens_closes_or_ran("closed_call_for_evidence", "call_for_evidence")).to eq("This call for evidence ran from")
      end

      it "returns ran_from text when document type is call_for_evidence_outcome" do
        expect(opens_closes_or_ran("call_for_evidence_outcome", "call_for_evidence")).to eq("This call for evidence ran from")
      end

      it "returns closes_at text when document type is open_call_for_evidence" do
        expect(opens_closes_or_ran("open_call_for_evidence", "call_for_evidence")).to eq("This call for evidence closes at")
      end

      it "returns opens at text when document type is call_for_evidence" do
        expect(opens_closes_or_ran("call_for_evidence", "call_for_evidence")).to eq("This call for evidence opens at")
      end
    end
  end
end
