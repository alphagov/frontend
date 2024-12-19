class TransactionPresenter < ContentItemModelPresenter
  def tab_count
    [
      content_item.more_information,
      content_item.what_you_need_to_know,
      content_item.other_ways_to_apply,
    ].count(&:present?)
  end

  def multiple_more_information_sections?
    tab_count > 1
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
