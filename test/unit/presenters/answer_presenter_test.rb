require "test_helper"

class AnswerPresenterTest < ActiveSupport::TestCase
  def subject(content_item)
    AnswerPresenter.new(content_item.deep_stringify_keys!)
  end

  test "#body" do
    assert_equal 'foo', subject(details: { body: 'foo' }).body
  end
end
