class WorkingGroup < ContentItem
  attr_reader :headers, :policies

  def initialize(content_store_response)
    super(content_store_response)

    @headers = content_store_response.dig("details", "headers") || []
    @policies = linked("policies")
  end
end
