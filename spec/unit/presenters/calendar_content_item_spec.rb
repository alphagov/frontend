require "govuk_schemas/rspec_matchers"

RSpec.describe CalendarContentItem do
  include GovukSchemas::RSpecMatchers

  def calendar_content_item(slug: nil)
    calendar = Calendar.find("bank-holidays")
    described_class.new(calendar, slug:)
  end

  describe "#payload" do
    it "returns correct data for an english item" do
      payload = calendar_content_item.payload

      expect(payload).to be_valid_against_publisher_schema("calendar")
      expect(payload[:title]).to eq("UK bank holidays")
      expect(payload[:locale]).to eq("en")
    end

    it "contains correct data for a welsh item" do
      payload = I18n.with_locale(:cy) { calendar_content_item.payload }

      expect(payload).to be_valid_against_publisher_schema("calendar")
      expect(payload[:title]).to eq("Gwyliau banc y DU")
      expect(payload[:locale]).to eq("cy")
    end
  end

  describe "#base_path" do
    it "is correct for an english item" do
      base_path = calendar_content_item.base_path

      expect(base_path).to eq("/bank-holidays")
    end

    it "is correct for a welsh item" do
      base_path = I18n.with_locale(:cy) { calendar_content_item(slug: "gwyliau-banc").base_path }

      expect(base_path).to eq("/gwyliau-banc")
    end
  end
end
