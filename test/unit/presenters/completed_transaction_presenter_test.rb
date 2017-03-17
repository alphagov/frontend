require "test_helper"

class CompletedTransactionPresenterTest < ActiveSupport::TestCase
  def subject(content_item)
    CompletedTransactionPresenter.new(content_item.deep_stringify_keys!)
  end

  test "#promotion" do
    assert_equal 'organ-donation', subject(details: { promotion: 'organ-donation' }).promotion
  end
end
