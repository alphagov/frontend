require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  class ApplicationHelperContainer
    include ApplicationHelper
    include ActionView::Helpers::TagHelper

    def request
      @request ||= OpenStruct.new(:format => OpenStruct.new(:video? => false))
    end
  end

  def setup
    @helper = ApplicationHelperContainer.new
  end

  def basic_artefact
    OpenStruct.new(section: 'missing', need_id: 'missing', kind: 'missing')
  end

  test "the page title always ends with GOV.UK" do
    assert_equal 'GOV.UK', @helper.page_title(basic_artefact).split.last
  end

  test "the page title doesn't contain consecutive pipes" do
    assert_no_match %r{\|\s*\|}, @helper.page_title(basic_artefact)
  end

  test "the page title does not includes the publication alternative title if one's set" do
    publication = OpenStruct.new(alternative_title: 'I am an alternative', title: 'I am not')
    title = @helper.page_title(basic_artefact, publication)
    assert_no_match %r{I am an alternative}, title
    assert_match %r{I am not}, title
  end

  test "the page title doesn't blow up if the publication titles are nil" do
    publication = OpenStruct.new(title: nil)
    assert @helper.page_title(basic_artefact, publication)
  end

  test "it correctly identifies a video guide in the wrapper classes" do
    @helper.request.format.stubs(:video?).returns(true)
    guide = OpenStruct.new(:type => 'guide')
    assert @helper.wrapper_class(guide).split.include?('video-guide')
  end

  test "it marks local transactions as a service" do
    local_transaction = OpenStruct.new(:type => 'local_transaction')
    assert @helper.wrapper_class(local_transaction).split.include?('service')
  end

  test "should build title from publication and artefact" do
    publication = OpenStruct.new(title: "Title")
    artefact = OpenStruct.new(section: "Section")
    assert_equal "Title | Section | GOV.UK", @helper.page_title(artefact, publication)
  end

  test "should prefix title of video with video" do
    @helper.request.format.stubs(:video?).returns(true)
    publication = OpenStruct.new(title: "Title")
    assert_match /^Video - Title/, @helper.page_title(basic_artefact, publication)
  end

  test "should omit artefact section if missing" do
    publication = OpenStruct.new(title: "Title")
    artefact = OpenStruct.new(section: "")
    assert_equal "Title | GOV.UK", @helper.page_title(artefact, publication)
  end

  test "should omit first part of title if publication is omitted" do
    @helper.request.format.stubs(:video?).returns(true)
    artefact = OpenStruct.new(section: "Section")
    assert_equal "Section | GOV.UK", @helper.page_title(artefact)
  end

  test "section_meta_tags return empty string if no artefact given" do
    assert_equal '', @helper.section_meta_tags(nil)
  end

  test "section_meta_tags return empty string if artefact not in section" do
    artefact = OpenStruct.new
    assert_equal '', @helper.section_meta_tags(artefact)
  end

  test "section_meta_tags returns three meta tags if artefact has a section" do
    artefact = OpenStruct.new(section: "My Section")
    response = @helper.section_meta_tags(artefact)

    assert_equal 3, response.scan(/<meta/).count
    assert response.match(/name="x-section-name"/)
    assert response.match(/content="My Section"/)
  end
end
