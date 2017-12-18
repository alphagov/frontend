require 'test_helper'

class TasklistContentTest < ActiveSupport::TestCase
  context "learning to drive a car tasklist" do
    setup do
      @config = GovukNavigationHelpers::TasklistContent.current_tasklist("/vehicles-can-drive")
    end

    should "be configured for a sidebar" do
      assert_equal 3, @config.tasklist[:heading_level]
      assert_equal true, @config.tasklist[:small]
    end

    should "have symbolized keys" do
      @config.tasklist.each_key do |key|
        assert key.is_a? Symbol
      end
    end

    should "have a link in the correct structure" do
      assert_equal "Check you're allowed to drive", @config.tasklist[:groups][0][0][:title]
    end
  end
end
