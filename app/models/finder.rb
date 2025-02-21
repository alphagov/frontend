class Finder < ContentItem
  attr_reader :facets

  def initialize(content_store_response)
    super(content_store_response)

    @facets = content_store_response.dig("details", "facets")
  end
end
