class ServiceManualServiceToolkit < ContentItem
  attr_reader :collections

  def initialize(content_store_response)
    super(content_store_response)

    @collections = content_store_response.dig("details", "collections") || []
  end
end
