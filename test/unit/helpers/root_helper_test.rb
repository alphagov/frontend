require 'test_helper'

class RootHelperTest < ActionView::TestCase
  include RootHelper
  test "if given bad values it returns a part number of -" do
    assert_equal "-", part_number([], 1)
  end
end
