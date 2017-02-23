require 'test_helper'
require 'ostruct'

class ProgrammePartHelperTest < ActionView::TestCase
  include ProgrammePartHelper

  setup do
    @model = PublicationWithPartsPresenter.new(JSON.parse(
                                                 File.read(
                                                   Rails.root.join("test/fixtures/child-tax-credit.json")
                                                 )
    ))
  end

  test "if given bad values it returns a part number of -" do
    assert_equal "-", programme_part_number([], 1)
  end

  context "path_part" do
    should "create a basic publication path" do
      assert_equal "/the-slug", programme_part_path("the-slug")
    end

    should "create a path with the part if provided" do
      assert_equal "/the-slug/the-part", programme_part_path("the-slug", "the-part")
    end

    should "create a path with the part and edition if provided" do
      assert_equal "/the-slug/the-part?edition=1", programme_part_path("the-slug", "the-part", 1)
    end
  end

  context "previous_part_path" do
    should "show previous part path if available" do
      assert_equal "/child-tax-credit/adoptive-or-foster-parents?edition=1", programme_previous_part_path(@model, @model.parts[3], 1)
    end

    should "fail if there is no previous part" do
      assert_raises("No previous part") do
        programme_previous_part_path(@model, @model.parts[0], 1)
      end
    end
  end

  context "next_part_path" do
    should "show next part path if available" do
      assert_equal "/child-tax-credit/adoptive-or-foster-parents?edition=1", programme_next_part_path(@model, @model.parts[1], 1)
    end

    should "show fail if there is no next part" do
      assert_raises("No next part") do
        programme_next_part_path(@model, @model.parts[5], 1)
      end
    end
  end

  context "parts_column_height" do
    context "with number of parts below or equal the default column height" do
      should "return the default column height for 0 parts" do
        parts = []
        assert_equal programme_parts_column_height(parts), DEFAULT_COLUMN_HEIGHT
      end

      should "return the default column height for 1 part" do
        parts = [{ slug: "overview" }]
        assert_equal programme_parts_column_height(parts), DEFAULT_COLUMN_HEIGHT
      end

      should "return the default column height for 6 parts" do
        parts = [*1..6].map { |n| { slug: "slug_#{n}" } }
        assert_equal programme_parts_column_height(parts), DEFAULT_COLUMN_HEIGHT
      end
    end

    context "with number of parts above the default column height" do
      should "return 4 for 7 parts" do
        parts = [*1..7].map { |n| { slug: "slug_#{n}" } }
        assert_equal programme_parts_column_height(parts), 4
      end
    end
  end
end
