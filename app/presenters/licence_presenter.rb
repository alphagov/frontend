class LicencePresenter < ContentItemPresenter
  PASS_THROUGH_DETAILS_KEYS = %i[
    continuation_link
    licence_identifier
    licence_overview
    licence_short_description
    will_continue_on
  ].freeze

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      details[key.to_s] if details
    end
  end
end
