require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  test "it correctly identifies a video guide in the wrapper classes" do
  	guide = OpenStruct.new(:type => 'guide')
  	video_mode = true
  	assert body_wrapper_class(guide, video_mode).split.include?('video-guide')
  end
end
