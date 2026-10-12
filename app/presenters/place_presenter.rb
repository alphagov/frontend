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

  def map_allowed?
    Rails.application.config.allowed_geojson_slugs.include?(content_item.place_type)
  end

  def map_bounds
    bounds = [180.0, 90.0, -180.0, -90.0]
    places.each_with_object(bounds) do |place, bounds|
      bounds[0] = [place["location"]["longitude"], bounds[0]].min
      bounds[1] = [place["location"]["latitude"], bounds[1]].min
      bounds[2] = [place["location"]["longitude"], bounds[2]].max
      bounds[3] = [place["location"]["latitude"], bounds[3]].max
    end
    bounds
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
