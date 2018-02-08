require 'test_helper'

class TasklistContentTest < ActiveSupport::TestCase
  context "learning to drive a car tasklist" do
    setup do
      @config = GovukNavigationHelpers::StepNavContent.current_step_nav("/vehicles-can-drive")
    end

    should "be configured for a sidebar" do
      assert_equal 3, @config.step_nav[:heading_level]
      assert_equal true, @config.step_nav[:small]
    end

    should "have symbolized keys" do
      @config.step_nav.each_key do |key|
        assert key.is_a? Symbol
      end
    end

    should "have a link in the correct structure" do
      assert_equal "Check you're allowed to drive", @config.step_nav[:steps][0][:title]
    end
  end
end
