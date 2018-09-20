require "test_helper"

class PlacePresenterTest < ActiveSupport::TestCase
  def subject(content_item)
    @subject ||= PlacePresenter.new(content_item.deep_stringify_keys!)
  end

  test "#introduction" do
    assert_equals_foo subject(details: { introduction: 'foo' }).introduction
  end

  test "#more_information" do
    assert_equals_foo subject(details: { more_information: 'foo' }).more_information
  end

  test "#need_to_know" do
    assert_equals_foo subject(details: { need_to_know: 'foo' }).need_to_know
  end

  test "#place_type" do
    assert_equals_foo subject(details: { place_type: 'foo' }).place_type
  end

  test "#places" do
    places = [
      {
        "address1" => "44",
        "address2" => "Foo Foo Forest",
        "url" => "http://www.example.com/foo_foo_foorentinafoo"
      }
    ]

    expected = [
      {
        "address1" => "44",
        "address2" => "Foo Foo Forest",
        "url" => "http://www.example.com/foo_foo_foorentinafoo",
        "text" => "http://www.example.com/foo_foo_foorentinafoo",
        "address" => "44, Foo Foo Forest"
      }
    ]

    assert_equal expected, PlacePresenter.new({}, places).places
  end

  def assert_equals_foo(val)
    assert_equal 'foo', val
  end
end
