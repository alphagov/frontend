class TransactionPresenter < ContentItemPresenter
  def use_contextual_components?
    true
  end

  def page_title_options
    super.merge({
      lead_paragraph: nil,
    })
  end

  def start_button_text
    if content_item.start_button_text.blank?
      return I18n.t("formats.start_now")
    end

    case content_item.start_button_text
    when "Start now"
      I18n.t("formats.start_now")
    when "Sign in"
      I18n.t("formats.transaction.sign_in")
    else
      content_item.start_button_text
    end
  end
end
