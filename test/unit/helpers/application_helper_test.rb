require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  tests ApplicationHelper

  def dummy_publication
    ContentItemPresenter.new(content_store_has_random_item(base_path: '/dummy'))
  end

  test "the page title doesn't contain consecutive pipes" do
    assert_no_match %r{\|\s*\|}, page_title(dummy_publication)
  end

  test "the page title doesn't blow up if the publication titles are nil" do
    publication = OpenStruct.new(title: nil)
    assert page_title(publication)
  end

  context "wrapper_class" do
    should "mark local transactions as a service" do
      local_transaction = OpenStruct.new(format: 'local_transaction')
      assert wrapper_class(local_transaction).split.include?('service')
    end
  end

  test "should build title from content items" do
    publication = OpenStruct.new(title: "Title")
    assert_equal "Title - GOV.UK", page_title(publication)
  end

  test "should omit first part of title if publication is omitted" do
    assert_equal "GOV.UK", page_title
  end

  context '#current_path_without_query_string' do
    should "return the path of the current request" do
      self.stubs(:request).returns(ActionDispatch::TestRequest.new("PATH_INFO" => '/foo/bar'))
      assert_equal '/foo/bar', current_path_without_query_string
    end

    should "return the path of the current request stripping off any query string parameters" do
      self.stubs(:request).returns(ActionDispatch::TestRequest.new("PATH_INFO" => '/foo/bar', "QUERY_STRING" => 'ham=jam&spam=gram'))
      assert_equal '/foo/bar', current_path_without_query_string
    end
  end
end
