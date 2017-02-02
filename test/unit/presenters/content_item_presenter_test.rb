require "test_helper"

class ContentItemPresenterTest < ActiveSupport::TestCase
  def subject(content_item)
    ContentItemPresenter.new(content_item.deep_stringify_keys!)
  end

  test "#body" do
    assert_equals_foo subject(details: { body: 'foo' }).body
  end

  test "#base_path" do
    assert_equals_foo subject(base_path: 'foo').base_path
  end

  test "#in_beta" do
    assert_not subject(phase: 'live').in_beta
    assert subject(phase: 'beta').in_beta
  end

  test "#slug" do
    assert_equals_foo subject(base_path: '/foo').slug
  end

  test "#format" do
    assert_equals_foo subject(schema_name: 'foo').format
  end

  test "#short_description" do
    assert_nil subject({}).short_description
  end

  test "#updated_at" do
    datetime = 1.minute.ago
    assert_equal datetime.to_i, subject(updated_at: datetime.to_s).updated_at.to_i
  end

  def assert_equals_foo(val)
    assert_equal 'foo', val
  end
end
