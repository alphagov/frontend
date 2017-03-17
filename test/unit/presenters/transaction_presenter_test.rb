require 'test_helper'

class TransactionPresenterTest < ActiveSupport::TestCase
  def subject(content_item)
    TransactionPresenter.new(content_item.deep_stringify_keys!)
  end

  context "details" do
    setup do
      @item = {
        details: {
          introductory_paragraph: "foo",
          more_information: "bar",
          other_ways_to_apply: "carrots",
          transaction_start_link: "bananas",
          what_you_need_to_know: "hats",
          will_continue_on: "scarves"
        }
      }
    end

    should "#introductory_paragraph" do
      assert_equal "foo", subject(@item).introductory_paragraph
    end

    should "#more_information" do
      assert_equal "bar", subject(@item).more_information
    end

    should "#other_ways_to_apply" do
      assert_equal "carrots", subject(@item).other_ways_to_apply
    end

    should "#transaction_start_link" do
      assert_equal "bananas", subject(@item).transaction_start_link
    end

    should "#what_you_need_to_know" do
      assert_equal "hats", subject(@item).what_you_need_to_know
    end

    should "#will_continue_on" do
      assert_equal "scarves", subject(@item).will_continue_on
    end
  end

  context "multiple_more_information_sections?" do
    should "be false with no sections" do
      assert_not subject({}).multiple_more_information_sections?
    end

    should "be false with only one section" do
      item = { details: { more_information: "carrots" } }
      assert_not subject(item).multiple_more_information_sections?
    end

    should "be true if there are multiple sections" do
      item = { details: { more_information: "carrots", what_you_need_to_know: "all about carrots" } }
      assert subject(item).multiple_more_information_sections?
    end
  end

  context "#open_in_new_window?" do
    should "load transaction in new window if slug is in list" do
      assert subject(base_path: "/apply-blue-badge").open_in_new_window?
    end

    should "not load transaction in new window if slug is not in list" do
      assert_not subject(base_path: "/not-in-the-list").open_in_new_window?
    end
  end
end
