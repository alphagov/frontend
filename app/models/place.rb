class Place < ContentItem
  attr_reader :introduction, :more_information, :need_to_know, :place_type

  def initialize(content_store_response)
    super(content_store_response)

    @introduction = content_store_response.dig("details", "introduction")
    @more_information = content_store_response.dig("details", "more_information")
    @need_to_know = content_store_response.dig("details", "need_to_know")
    @place_type = content_store_response.dig("details", "place_type")
  end
end
