require "test_helper"

class PublicationPresenterTest < ActiveSupport::TestCase
  def subject(content_item)
    PublicationPresenter.new(content_item.deep_stringify_keys!)
  end

  test "#format" do
    assert_equals_foo subject(format: 'foo').format
  end

  test "#locale" do
    assert_equals_foo subject(details: { language: 'foo' }).locale
  end

  def assert_equals_foo(val)
    assert_equal 'foo', val
  end
end
