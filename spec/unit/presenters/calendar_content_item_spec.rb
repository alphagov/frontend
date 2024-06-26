require "govuk_schemas/assert_matchers"

RSpec.describe CalendarContentItem, type: :model do
  include GovukSchemas::AssertMatchers

  def calendar_content_item(slug: nil)
    calendar = Calendar.find("bank-holidays")
    described_class.new(calendar, slug:)
  end

  it "contains correct data for an english payload" do
    payload = calendar_content_item.payload

    assert_valid_against_publisher_schema(payload, "calendar")
    expect(payload[:title]).to eq("UK bank holidays")
    expect(payload[:locale]).to eq("en")
  end

  it "has a correct english base path" do
    base_path = calendar_content_item.base_path

    expect(base_path).to eq("/bank-holidays")
  end

  it "contains correct data for a welsh payload" do
    payload = I18n.with_locale(:cy) { calendar_content_item.payload }

    assert_valid_against_publisher_schema(payload, "calendar")
    expect(payload[:title]).to eq("Gwyliau banc y DU")
    expect(payload[:locale]).to eq("cy")
  end

  it "has a correct welsh base path" do
    base_path = I18n.with_locale(:cy) { calendar_content_item(slug: "gwyliau-banc").base_path }

    expect(base_path).to eq("/gwyliau-banc")
  end
end
