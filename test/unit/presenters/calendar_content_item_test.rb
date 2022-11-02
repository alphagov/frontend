require "test_helper"
require "govuk_schemas/assert_matchers"

class CalendarContentItemTest < ActiveSupport::TestCase
  include GovukSchemas::AssertMatchers

  def content_item(slug: nil)
    calendar = Calendar.find("bank-holidays")
    CalendarContentItem.new(calendar, slug: slug)
  end

  def test_english_payload_contains_correct_data
    payload = content_item.payload

    assert_valid_against_publisher_schema payload, "calendar"
    assert_equal "UK bank holidays", payload[:title]
    assert_equal "en", payload[:locale]
  end

  def test_english_base_path_is_correct
    base_path = content_item.base_path

    assert_equal "/bank-holidays", base_path
  end

  def test_welsh_payload_contains_correct_data
    payload = I18n.with_locale(:cy) { content_item.payload }

    assert_valid_against_publisher_schema payload, "calendar"
    assert_equal "Gwyliau banc y DU", payload[:title]
    assert_equal "cy", payload[:locale]
  end

  def test_welsh_base_path_is_correct
    base_path = I18n.with_locale(:cy) { content_item(slug: "gwyliau-banc").base_path }

    assert_equal "/gwyliau-banc", base_path
  end
end
