class TransactionPresenter < ContentItemPresenter
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
