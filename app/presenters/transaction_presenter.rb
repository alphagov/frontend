class TransactionPresenter < ContentItemPresenter
  PASS_THROUGH_DETAILS_KEYS = %i(
    introductory_paragraph
    more_information
    other_ways_to_apply
    transaction_start_link
    what_you_need_to_know
    will_continue_on
    department_analytics_profile
    downtime_message
  ).freeze

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      details[key.to_s] if details
    end
  end

  def multiple_more_information_sections?
    [more_information, what_you_need_to_know, other_ways_to_apply].count(&:present?) > 1
  end

  def start_button_text
    unless details && details["start_button_text"].present?
      return I18n.t("formats.transaction.start_now")
    end

    if details["start_button_text"] == "Start now"
      I18n.t("formats.transaction.start_now")
    elsif details["start_button_text"] == "Sign in"
      I18n.t("formats.transaction.sign_in")
    else
      details["start_button_text"]
    end
  end
end
