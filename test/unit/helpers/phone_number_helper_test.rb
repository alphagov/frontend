require "test_helper"

class PhoneNumberHelperTest < ActionView::TestCase
  include PhoneNumberHelper

  setup do
    @sample_phone_text = "023 4567 8910 (with some text)"
  end

  test "#phone_digits" do
    assert_equal "023 4567 8910", phone_digits(@sample_phone_text)
  end

  test "#phone_text" do
    assert_equal "(with some text)", phone_text(@sample_phone_text)
  end
end
