require "test_helper"

class CompletedTransactionPresenterTest < ActiveSupport::TestCase
  def subject(details)
    CompletedTransactionPresenter.new(details.deep_stringify_keys!)
  end

  test "#promotion" do
    content_item = { details: { promotion: { category: 'organ_donor' } } }
    assert subject(content_item).promotion.organ_donor?
  end
end
