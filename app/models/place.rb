# This is really a PlacesManager service (with multiple actual addresses/places)
# but the current schema_name is place, so stick with that for the moment
class Place < ContentItem
  attr_reader :introduction, :more_information, :need_to_know, :place_type

  def initialize(content_store_response, override_content_store_hash: nil)
    super

    @introduction = content_store_hash.dig("details", "introduction")
    @more_information = content_store_hash.dig("details", "more_information")
    @need_to_know = content_store_hash.dig("details", "need_to_know")
    @place_type = content_store_hash.dig("details", "place_type")
  end
end
