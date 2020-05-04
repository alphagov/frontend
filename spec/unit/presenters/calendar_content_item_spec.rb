RSpec.describe CalendarContentItem do
  let(:calendar) { Calendar.find("bank-holidays") }

  it "is valid against the schema" do
    expect(CalendarContentItem.new(calendar).payload).to be_valid_against_schema("calendar")
  end

  it "contains the correct title" do
    expect(CalendarContentItem.new(calendar).payload[:title]).to eq("UK bank holidays")
  end

  it "contains the correct base path" do
    expect(CalendarContentItem.new(calendar).base_path).to eq("/bank-holidays")
  end

  it "contains the correct locale" do
    expect(CalendarContentItem.new(calendar).payload[:locale]).to eq("en")
  end

  context "localised content items" do
    before { I18n.locale = :cy }
    after { I18n.locale = :en }

    it "contains the correct title" do
      expect(CalendarContentItem.new(calendar).payload[:title]).to eq("Gwyliau banc y DU")
    end

    it "contains the correct base path" do
      expect(CalendarContentItem.new(calendar, slug: "gwyliau-banc").base_path).to eq("/gwyliau-banc")
    end

    it "contains the correct locale" do
      expect(CalendarContentItem.new(calendar).payload[:locale]).to eq("cy")
    end
  end
end
