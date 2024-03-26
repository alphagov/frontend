class PlacePresenter < ContentItemPresenter
  PASS_THROUGH_DETAILS_KEYS = %i[
    introduction
    more_information
    need_to_know
    place_type
  ].freeze

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      details[key.to_s] if details
    end
  end

  attr_reader :places

  def initialize(content_item, places = [])
    super(content_item)
    @places = format_places(places)
  end

  def preposition
    return "near" unless @places&.any?

    @places.first["gss"].blank? ? "near" : "for"
  end

private

  def format_places(places)
    places.each do |place|
      place["text"]    = place["url"] if place["url"]
      place["address"] = place
                           .values_at("address1", "address2")
                           .compact
                           .map(&:strip)
                           .join(", ")
    end
  end
end
