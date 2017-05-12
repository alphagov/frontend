require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  class ApplicationHelperContainer
    include ApplicationHelper
    include ActionView::Helpers::TagHelper

    def request
      @request ||= OpenStruct.new(format: OpenStruct.new)
    end
  end

  def setup
    @helper = ApplicationHelperContainer.new
  end

  def dummy_publication
    ContentItemPresenter.new(content_store_has_random_item(base_path: '/dummy'))
  end

  test "the page title doesn't contain consecutive pipes" do
    assert_no_match %r{\|\s*\|}, @helper.page_title(dummy_publication)
  end

  test "the page title doesn't blow up if the publication titles are nil" do
    publication = OpenStruct.new(title: nil)
    assert @helper.page_title(publication)
  end

  context "wrapper_class" do
    should "mark local transactions as a service" do
      local_transaction = OpenStruct.new(format: 'local_transaction')
      assert @helper.wrapper_class(local_transaction).split.include?('service')
    end
  end

  test "should build title from content items" do
    publication = OpenStruct.new(title: "Title")
    assert_equal "Title - GOV.UK", @helper.page_title(publication)
  end

  test "should omit first part of title if publication is omitted" do
    assert_equal "GOV.UK", @helper.page_title
  end
end
