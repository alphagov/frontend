class HelpPagePresenter < ContentItemPresenter
  PASS_THROUGH_DETAILS_KEYS = [
    :body
  ].freeze

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      details[key.to_s] if details
    end
  end
end
