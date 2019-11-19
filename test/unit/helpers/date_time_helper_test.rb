require "test_helper"

class DateTimeHelperTest < ActionView::TestCase
  include DateTimeHelper

  setup do
    @sample_date = "2019-11-12"
  end

  test "#format_date" do
    assert_equal "12 November 2019", format_date(@sample_date)
  end
end
