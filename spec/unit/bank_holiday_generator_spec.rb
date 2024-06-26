RSpec.describe BankHolidayGenerator, type: :model do
  def self.generates_correct_bank_holidays(nation, year, locale, file_name)
    it "generates bank holidays correctly in #{nation} for year #{year}" do
      I18n.locale = locale
      bank_holidays = JSON.parse(IO.read((Rails.root + "./spec/fixtures/#{file_name}"))).fetch("divisions")
      bank_holiday_generator = BankHolidayGenerator.new(year, nation)
      generated_bank_holidays = bank_holiday_generator.perform
      translated_bank_holidays = generated_bank_holidays.map do |bank_holiday|
        bank_holiday["title"] = I18n.t(bank_holiday["title"])
        unless bank_holiday["notes"].empty?
          bank_holiday["notes"] = I18n.t(bank_holiday["notes"])
        end
        bank_holiday
      end

      expect(translated_bank_holidays).to eq(bank_holidays.fetch(nation).fetch(year.to_s))
    end
  end

  nations = %w[england-and-wales scotland northern-ireland]
  years = (2013..2016)
  nations.each do |nation|
    years.each do |year|
      generates_correct_bank_holidays(nation, year, :en, "bank-holidays_translated.json")
      generates_correct_bank_holidays(nation, year, :cy, "gwyliau-banc_translated.json")
    end
  end

  it "generates bank holidays in order" do
    bank_holiday_generator = BankHolidayGenerator.new(2016, "england-and-wales")
    generated_bank_holidays = bank_holiday_generator.perform
    index_of_christmas = generated_bank_holidays.each_index.find do |i|
      (generated_bank_holidays[i]["title"] == "bank_holidays.christmas")
    end
    index_of_boxing_day = generated_bank_holidays.each_index.find do |i|
      (generated_bank_holidays[i]["title"] == "bank_holidays.boxing_day")
    end

    expect((index_of_boxing_day < index_of_christmas)).to be_truthy
  end

  context "new year's day is on a Saturday" do
    bank_holiday_generator = BankHolidayGenerator.new(2022, "scotland")
    generated_bank_holidays = bank_holiday_generator.perform

    it "moves new year's day to the Tuesday in Scotland" do
      new_year = generated_bank_holidays.find do |holiday|
        (holiday["title"] == "bank_holidays.new_year")
      end

      expect((new_year["date"] == "04/01/2022")).to be_truthy
      expect((new_year["notes"] == "common.substitute_day")).to be_truthy
    end

    it "moves January 2nd to the Monday in Scotland" do
      jan_2nd = generated_bank_holidays.find do |holiday|
        (holiday["title"] == "bank_holidays.2nd_january")
      end

      expect((jan_2nd["date"] == "03/01/2022")).to be_truthy
      expect((jan_2nd["notes"] == "common.substitute_day")).to be_truthy
    end
  end

  context "new year's day is on a Sunday" do
    bank_holiday_generator = BankHolidayGenerator.new(2017, "scotland")
    generated_bank_holidays = bank_holiday_generator.perform

    it "moves new year's day to the Tuesday in Scotland" do
      new_year = generated_bank_holidays.find do |holiday|
        (holiday["title"] == "bank_holidays.new_year")
      end

      expect((new_year["date"] == "03/01/2017")).to be_truthy
      expect((new_year["notes"] == "common.substitute_day")).to be_truthy
    end

    it "does not move January 2nd in Scotland" do
      jan_2nd = generated_bank_holidays.find do |holiday|
        (holiday["title"] == "bank_holidays.2nd_january")
      end

      expect((jan_2nd["date"] == "02/01/2017")).to be_truthy
    end
  end
end
