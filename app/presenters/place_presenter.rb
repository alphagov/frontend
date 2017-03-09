class PlacePresenter < ContentItemPresenter
  PASS_THROUGH_DETAILS_KEYS = %i(
    introduction
    more_information
    need_to_know
    place_type
  ).freeze

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      details[key.to_s] if details
    end
  end
end
