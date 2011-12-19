require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  def basic_artefact
    OpenStruct.new(section: 'missing', need_id: 'missing', kind: 'missing')
  end

  # Anyone with better ideas of how to stub request.format.video? in a helper feel free
  # to amend!
  def format
    self
  end

  def video?
    true
  end

  def request
    self
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

  test "the page title doesn't blow up if the publication titles are nil" do
    publication = OpenStruct.new(title: nil)
    assert page_title(basic_artefact, publication)
  end

  test "it correctly identifies a video guide in the wrapper classes" do
    guide = OpenStruct.new(:type => 'guide')
    assert wrapper_class(guide).split.include?('video-guide')
  end
end
