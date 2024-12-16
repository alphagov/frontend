RSpec.describe Calendar::Event do
  describe "#date" do
    it "parses a date given as a string" do
      e = described_class.new("date" => "2012-02-04")

      expect(e.date).to eq(Date.civil(2012, 2, 4))
    end

    it "allows construction with dates as well as string dates" do
      e = described_class.new("date" => Date.civil(2012, 2, 4))

      expect(e.date).to eq(Date.civil(2012, 2, 4))
    end
  end

  describe "#as_json" do
    it "returns a hash representation" do
      I18n.locale = :en
      e = described_class.new("title" => "bank_holidays.new_year", "date" => "02/01/2012", "notes" => "common.substitute_day", "bunting" => true)
      expected = { "title" => "New Year\u2019s Day", "date" => Date.civil(2012, 1, 2), "notes" => "Substitute day", "bunting" => true }

      expect(e.as_json).to eq(expected)
    end
  end
end
