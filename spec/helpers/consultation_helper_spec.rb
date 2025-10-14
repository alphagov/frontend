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
end
