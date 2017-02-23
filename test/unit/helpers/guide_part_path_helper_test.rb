require 'test_helper'

class GuidePartPathHelperTest < ActionView::TestCase
  include GuidePartPathHelper

  def presented_model
    @_ ||= GuidePresenter.new(content_item)
  end

  def content_item
    {
      "base_path" => "foo",
      "details" => {
        "parts" => [
          part('one'),
          part('two'),
          part('three')
        ]
      }
    }
  end

  def part(label)
    {
      "title" => label,
      "slug" => label,
      "body" => [
        {
          "content_type" => "text/govspeak",
          "content" => label
        }
      ]
    }
  end

  context "#current_part_path" do
    should "show current part path" do
      presented_model.current_part = 'two'
      assert_equal "/foo/two", current_part_path(presented_model)
    end
  end

  context "#previous_part_path" do
    should "show previous part path" do
      presented_model.current_part = 'two'
      assert_equal "/foo/one", previous_part_path(presented_model)
    end
  end

  context "#next_part_path" do
    should "show next part path" do
      presented_model.current_part = 'two'
      assert_equal "/foo/three", next_part_path(presented_model)
    end
  end

  context "parts_column_height" do
    context "with number of parts below or equal the default column height" do
      should "return the default column height for 0 parts" do
        parts = []
        assert_equal parts_column_height(parts), DEFAULT_COLUMN_HEIGHT
      end

      should "return the default column height for 1 part" do
        parts = [{ slug: "overview" }]
        assert_equal parts_column_height(parts), DEFAULT_COLUMN_HEIGHT
      end

      should "return the default column height for 6 parts" do
        parts = [*1..6].map { |n| { slug: "slug_#{n}" } }
        assert_equal parts_column_height(parts), DEFAULT_COLUMN_HEIGHT
      end
    end

    context "with number of parts above the default column height" do
      should "return 4 for 7 parts" do
        parts = [*1..7].map { |n| { slug: "slug_#{n}" } }
        assert_equal parts_column_height(parts), 4
      end
    end
  end
end
