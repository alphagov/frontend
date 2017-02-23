require "test_helper"

class GuidePresenterTest < ActiveSupport::TestCase
  def subject(content_item = {})
    @_ ||= GuidePresenter.new(content_item)
  end

  def parted_guide
    {
      "details" => {
        "parts" => [part('one'), part('two')]
      }
    }
  end

  def part(label)
    {
      "title" => label,
      "slug" => label,
      "body" => [
        {
          "content_type" => 'text/govspeak',
          "content" => label
        }
      ]
    }
  end

  def assert_parts_equal(part, presented_part)
    assert_equal part['title'], presented_part.title
    assert_equal part['slug'], presented_part.slug
    assert_equal part['body'], presented_part.body
  end

  context "#current_part and #current_part=" do
    should "set / return the current_part" do
      subject(parted_guide).current_part = 'two'
      assert_parts_equal part('two'), subject.current_part
    end

    should "set / return the first part if no part provided" do
      subject(parted_guide).current_part = nil
      assert_parts_equal part('one'), subject.current_part
    end
  end

  context "#part_not_found?" do
    should "return true if no @current_part is set" do
      assert subject(parted_guide).tap { |guide|
        guide.current_part = 'baz'
      }.part_not_found?
    end

    should "return false if there's a current_part" do
      assert_not subject(parted_guide).tap { |guide|
        guide.current_part = 'one'
      }.part_not_found?
    end
  end

  context "#current_part_number" do
    should "return the index of the current part" do
      assert_equal 2, subject(parted_guide).tap { |guide|
        guide.current_part = 'two'
      }.current_part_number
    end
  end

  context "#parts" do
    should "return all the decorated parts" do
      assert_parts_equal part('one'), subject(parted_guide).parts.first
      assert_parts_equal part('two'), subject(parted_guide).parts.second
    end
  end

  context "#empty_part_list?" do
    should "return false if there are parts" do
      assert_not subject(parted_guide).empty_part_list?
    end

    should "return true if there are no parts" do
      assert subject({}).empty_part_list?
    end
  end

  context "#has_parts?" do
    should "return true if there are parts" do
      assert subject(parted_guide).has_parts?
    end

    should "return false if there are no parts" do
      assert_not subject({}).has_parts?
    end
  end

  context "#next_part" do
    should "return the next part" do
      assert_parts_equal part('two'), subject(parted_guide).tap { |guide|
        guide.current_part = 'one'
      }.next_part
    end

    should "return nil if current_part is not set" do
      assert_nil subject(parted_guide).next_part
    end

    should "return nil if there is no next part" do
      assert_nil subject(parted_guide).tap { |guide|
        guide.current_part = 'two'
      }.next_part
    end
  end

  context "#previous_part" do
    should "return the previous part" do
      assert_parts_equal part('one'), subject(parted_guide).tap { |guide|
        guide.current_part = 'two'
      }.previous_part
    end

    should "return nil if current_part is not set" do
      assert_nil subject(parted_guide).previous_part
    end

    should "return nil if there is no previous part" do
      assert_nil subject(parted_guide).tap { |guide|
        guide.current_part = 'one'
      }.previous_part
    end
  end

  context "#has_previous_part?" do
    should "return true if there's a previous part" do
      assert subject(parted_guide).tap { |guide|
        guide.current_part = 'two'
      }.has_previous_part?
    end

    should "return false if there's no previous part" do
      assert_not subject(parted_guide).tap { |guide|
        guide.current_part = 'one'
      }.has_previous_part?
    end
  end

  context "#has_next_part?" do
    should "return true if there's a next part" do
      assert subject(parted_guide).tap { |guide|
        guide.current_part = 'one'
      }.has_next_part?
    end

    should "return false if there's no following part" do
      assert_not subject(parted_guide).tap { |guide|
        guide.current_part = 'two'
      }.has_next_part?
    end
  end
end
