require "test_helper"

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
          will_continue_on: "scarves",
          start_button_text: "Start now",
        },
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

    context "start_button_text is 'Start now'" do
      should "#start_button_text" do
        assert_equal "Start now", subject(@item).start_button_text
      end
    end

    context "start_button_text is 'Sign in'" do
      should "#start_button_text" do
        @item[:details][:start_button_text] = "Sign in"
        assert_equal "Sign in", subject(@item).start_button_text
      end
    end
  end

  context "locale is 'cy'" do
    setup do
      I18n.locale = :cy
      @item = {
        details: {
          start_button_text: "Start now",
        },
      }
    end

    context "start_button_text is 'Start now'" do
      should "return Welsh translation 'Dechrau nawr'" do
        assert_equal "Dechrau nawr", subject(@item).start_button_text
      end
    end

    context "start_button_text is 'Sign in'" do
      should "return Welsh translation 'Mewngofnodi'" do
        @item[:details][:start_button_text] = "Sign in"
        assert_equal "Mewngofnodi", subject(@item).start_button_text
      end
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

    should "count two tabs" do
      item = { details: { more_information: "potatoes", what_you_need_to_know: "all about potatoes" } }
      assert_equal subject(item).tab_count, 2
    end

    should "count three tabs" do
      item = { details: { more_information: "potatoes", what_you_need_to_know: "all about potatoes", other_ways_to_apply: "I just love potatoes" } }
      assert_equal subject(item).tab_count, 3
    end
  end
end
