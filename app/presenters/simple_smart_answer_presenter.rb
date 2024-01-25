class SimpleSmartAnswerPresenter < ContentItemPresenter
  PASS_THROUGH_DETAILS_KEYS = %i[
    body
    nodes
  ].freeze

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      details[key.to_s] if details
    end
  end

  def start_button_text
    unless details && details["start_button_text"].present?
      return I18n.t("formats.start_now")
    end

    if details["start_button_text"] == "Start now"
      I18n.t("formats.start_now")
    elsif details["start_button_text"] == "Continue"
      I18n.t("continue")
    else
      details["start_button_text"]
    end
  end
end
