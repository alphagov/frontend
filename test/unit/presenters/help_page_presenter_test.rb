require "test_helper"

class HelpPagePresenterTest < ActiveSupport::TestCase
  def subject(content_item)
    HelpPagePresenter.new(content_item.deep_stringify_keys!)
  end

  test "#body" do
    assert_equal 'foo', subject(details: { body: 'foo' }).body
  end
end
