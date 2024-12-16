class SimpleSmartAnswerPresenter < ContentItemModelPresenter
  def start_button_text
    if content_item.start_button_text == "Start now"
      I18n.t("formats.start_now")
    elsif content_item.start_button_text == "Continue"
      I18n.t("continue")
    else
      content_item.start_button_text
    end
  end
end
