require 'test_helper'

class TasklistContentTest < ActiveSupport::TestCase
  context "learning to drive a car tasklist" do
    setup do
      @config = TasklistContent.learn_to_drive_config
    end

    should "be configured for a sidebar" do
      assert_equal 3, @config[:tasklist][:heading_level]
      assert_equal true, @config[:tasklist][:small]
    end

    should "have symbolized keys" do
      @config.keys.each do |key|
        assert key.is_a? Symbol
      end
    end

    should "have a link in the correct structure" do
      first_link = @config[:tasklist][:steps][0][0][:panel_links][0]
      assert_equal "/vehicles-can-drive", first_link[:href]
      assert_equal "Check what age you can drive", first_link[:text]
    end
  end
end
