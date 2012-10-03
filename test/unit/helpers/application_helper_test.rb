require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ArtefactHelpers

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

  def missing_artefact
    artefact_unavailable
  end


  test "the page title always ends with (Test)" do
    assert_equal '(Test)', @helper.page_title(missing_artefact).split.last
  end

  test "the page title doesn't contain consecutive pipes" do
    assert_no_match %r{\|\s*\|}, @helper.page_title(missing_artefact)
  end

  test "the page title does not includes the publication alternative title if one's set" do
    publication = OpenStruct.new(alternative_title: 'I am an alternative', title: 'I am not')
    title = @helper.page_title(missing_artefact, publication)
    assert_no_match %r{I am an alternative}, title
    assert_match %r{I am not}, title
  end

  test "the page title doesn't blow up if the publication titles are nil" do
    publication = OpenStruct.new(title: nil)
    assert @helper.page_title(missing_artefact, publication)
  end

  context "wrapper_class" do
    should "correctly identifies a video guide in the wrapper classes" do
      @helper.request.format.stubs(:video?).returns(true)
      guide = OpenStruct.new(:type => 'guide')
      assert @helper.wrapper_class(guide).split.include?('video-guide')
    end

    should "mark local transactions as a service" do
      local_transaction = OpenStruct.new(:type => 'local_transaction')
      assert @helper.wrapper_class(local_transaction).split.include?('service')
    end
  end

  test "should build title from publication and artefact" do
    publication = OpenStruct.new(title: "Title")
    artefact = artefact_for_slug("slug")
    assert_equal "Title - GOV.UK Beta (Test)", @helper.page_title(artefact, publication)
  end

  test "should prefix title of video with video" do
    @helper.request.format.stubs(:video?).returns(true)
    publication = OpenStruct.new(title: "Title")
    assert_match /^Video - Title/, @helper.page_title(missing_artefact, publication)
  end

  test "should omit first part of title if publication is omitted" do
    @helper.request.format.stubs(:video?).returns(true)
    artefact = artefact_for_slug("slug")
    assert_equal "GOV.UK Beta (Test)", @helper.page_title(artefact)
  end
end
