require "test_helper"

class CurrencyHelperTest < ActionView::TestCase
  include CurrencyHelper

  setup do
    @sample_number = "12000"
  end

  test "#format_amount" do
    assert_equal "12,000 euros", format_amount(@sample_number)
  end
end
