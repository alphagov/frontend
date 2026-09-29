class SimpleSmartAnswerPresenter < ContentItemPresenter
  def use_contextual_components?
    true
  end

  def page_title_options
    super.merge({
      lead_paragraph: nil,
    })
  end

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
