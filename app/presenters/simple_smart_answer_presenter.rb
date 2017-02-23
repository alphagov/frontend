class SimpleSmartAnswerPresenter < ContentItemPresenter
  PASS_THROUGH_DETAILS_KEYS = [
    :body,
    :start_button_text,
    :nodes,
  ].freeze

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      details[key.to_s] if details
    end
  end
end
