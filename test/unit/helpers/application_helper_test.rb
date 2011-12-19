require 'test_helper'

class ApplicationHelperContainer
  include ApplicationHelper
  def request
    format = OpenStruct.new :video? => true
    OpenStruct.new :format => format
  end
end

class ApplicationHelperTest < ActionView::TestCase
  def setup
    @helper = ApplicationHelperContainer.new
  end

  def basic_artefact
    OpenStruct.new(section: 'missing', need_id: 'missing', kind: 'missing')
  end

  test "the page title always ends with www.gov.uk" do
    assert_equal 'www.gov.uk', @helper.page_title(basic_artefact).split.last
  end

  test "the page title doesn't contain consecutive pipes" do
    assert ! @helper.page_title(basic_artefact).match(/\|\s*\|/)
  end

  test "the page title includes the publication alternative title if one's set" do
    publication = OpenStruct.new(alternative_title: 'I am an alternative')
    assert @helper.page_title(basic_artefact, publication).match(/I am an alternative/)
  end

  test "the page title doesn't blow up if the publication titles are nil" do
    publication = OpenStruct.new(title: nil)
    assert @helper.page_title(basic_artefact, publication)
  end

  test "it correctly identifies a video guide in the wrapper classes" do
    guide = OpenStruct.new(:type => 'guide')
    assert @helper.wrapper_class(guide).split.include?('video-guide')
  end
end
