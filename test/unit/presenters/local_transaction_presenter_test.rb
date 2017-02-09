require "test_helper"

class LocalTransactionPresenterTest < ActiveSupport::TestCase
  def subject(content_item)
    LocalTransactionPresenter.new(content_item.deep_stringify_keys!)
  end

  test "#introduction" do
    assert_equal 'foo', subject(details: { introduction: 'foo' }).introduction
  end

  test "#more_information" do
    assert_equal 'foo', subject(details: { more_information: 'foo' }).more_information
  end

  test "#need_to_know" do
    assert_equal 'foo', subject(details: { need_to_know: 'foo' }).need_to_know
  end
end
