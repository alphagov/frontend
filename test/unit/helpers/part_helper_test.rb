require 'test_helper'
require 'ostruct'

class PartHelperTest < ActionView::TestCase
  include PartHelper

  setup do
    @model = PublicationPresenter.new(JSON.parse(
                                        File.read(
                                          Rails.root.join("test/fixtures/child-tax-credit.json")
                                        )
    ))
  end

  test "if given bad values it returns a part number of -" do
    assert_equal "-", part_number([], 1)
  end

  context "path_part" do
    should "create a basic publication path" do
      assert_equal "/the-slug", part_path("the-slug")
    end

    should "create a path with the part if provided" do
      assert_equal "/the-slug/the-part", part_path("the-slug", "the-part")
    end

    should "create a path with the part and edition if provided" do
      assert_equal "/the-slug/the-part?edition=1", part_path("the-slug", "the-part", 1)
    end
  end

  context "previous_part_path" do
    should "show previous part path if available" do
      assert_equal "/child-tax-credit/adoptive-or-foster-parents?edition=1", previous_part_path(@model, @model.parts[3], 1)
    end

    should "fail if there is no previous part" do
      assert_raises("No previous part") do
        previous_part_path(@model, @model.parts[0], 1)
      end
    end
  end

  context "next_part_path" do
    should "show next part path if available" do
      assert_equal "/child-tax-credit/adoptive-or-foster-parents?edition=1", next_part_path(@model, @model.parts[1], 1)
    end

    should "show fail if there is no next part" do
      assert_raises("No next part") do
        next_part_path(@model, @model.parts[5], 1)
      end
    end
  end
end
