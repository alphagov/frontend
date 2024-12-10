class PlacePresenter < ContentItemModelPresenter
  attr_reader :places

  def preposition
    return "near" unless formatted_places.any?

    formatted_places.first["gss"].blank? ? "near" : "for"
  end

private

  def formatted_places
    @formatted_places ||= content_item.places.each do |place|
      place["text"]    = place["url"] if place["url"]
      place["address"] = place
                           .values_at("address1", "address2")
                           .compact
                           .map(&:strip)
                           .join(", ")
    end
  end
end
