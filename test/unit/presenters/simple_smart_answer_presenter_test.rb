require "test_helper"

class SimpleSmartAnswerPresenterTest < ActiveSupport::TestCase
  def subject(content_item)
    SimpleSmartAnswerPresenter.new(content_item.deep_stringify_keys!)
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
  end
end
