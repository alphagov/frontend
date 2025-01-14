class PlacePresenter < ContentItemPresenter
  attr_reader :places

  def initialize(content_item, places = [])
    super(content_item)
    @places = format_places(places)
  end

  def preposition
    return "near" unless @places.any?

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
