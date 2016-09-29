require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  class ApplicationHelperContainer
    include ApplicationHelper
    include ActionView::Helpers::TagHelper

    def request
      @request ||= OpenStruct.new(format: OpenStruct.new(video?: false))
    end
  end

  def setup
    @helper = ApplicationHelperContainer.new
  end

  def dummy_publication
    PublicationPresenter.new(artefact_for_slug("dummy"))
  end

  test "the page title doesn't contain consecutive pipes" do
    assert_no_match %r{\|\s*\|}, @helper.page_title(dummy_publication)
  end

  test "the page title doesn't blow up if the publication titles are nil" do
    publication = OpenStruct.new(title: nil)
    assert @helper.page_title(publication)
  end

  context "wrapper_class" do
    should "correctly identifies a video guide in the wrapper classes" do
      @helper.request.format.stubs(:video?).returns(true)
      guide = OpenStruct.new(format: 'guide')
      assert @helper.wrapper_class(guide).split.include?('video-guide')
    end

    should "mark local transactions as a service" do
      local_transaction = OpenStruct.new(format: 'local_transaction')
      assert @helper.wrapper_class(local_transaction).split.include?('service')
    end

    should "mark travel advice as a guide" do
      travel_advice_edition = OpenStruct.new(format: 'travel-advice')
      assert @helper.wrapper_class(travel_advice_edition).split.include?('guide')
    end
  end

  test "should build title from publication and artefact" do
    publication = OpenStruct.new(title: "Title")
    assert_equal "Title - GOV.UK", @helper.page_title(publication)
  end

  test "should prefix title of video with video" do
    @helper.request.format.stubs(:video?).returns(true)
    publication = OpenStruct.new(title: "Title")
    assert_match /^Video - Title/, @helper.page_title(publication)
  end

  test "should omit first part of title if publication is omitted" do
    @helper.request.format.stubs(:video?).returns(true)
    assert_equal "GOV.UK", @helper.page_title
  end
end
