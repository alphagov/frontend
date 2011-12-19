require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  def basic_artefact
	OpenStruct.new(section: 'missing', need_id: 'missing', kind: 'missing')
  end

  test "the page title always ends with www.gov.uk" do
	assert_equal 'www.gov.uk', page_title(basic_artefact).split.last
  end

  test "the page title doesn't contain consecutive pipes" do
	assert ! page_title(basic_artefact).match(/\|\s*\|/)
  end

  test "the page title includes the publication alternative title if one's set" do
	publication = OpenStruct.new(alternative_title: 'I am an alternative')
  	assert page_title(basic_artefact, publication).match(/I am an alternative/)
  end

  test "it correctly identifies a video guide in the wrapper classes" do
  	guide = OpenStruct.new(:type => 'guide')
  	video_mode = true
  	assert body_wrapper_class(guide, video_mode).split.include?('video-guide')
  end
end
