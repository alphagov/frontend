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
end
