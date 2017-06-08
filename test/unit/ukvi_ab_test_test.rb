require "test_helper"

class UkviABTestTest < ActiveSupport::TestCase
  should "return true if path is valid path for AB test" do
    assert_equal UkviABTest.valid_path?("/remain-in-uk-family/overview"), true
    assert_equal UkviABTest.valid_path?("/join-family-in-uk"), true
  end

  should "return false if path is invalid path for AB test" do
    assert_equal UkviABTest.valid_path?("/invalid-path"), false
  end
end
