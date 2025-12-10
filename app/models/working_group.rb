class WorkingGroup < ContentItem
  attr_reader :email, :headers, :policies

  def initialize(content_store_response)
    super(content_store_response)

    @email = content_store_response.dig("details", "email")
    @headers = content_store_response.dig("details", "headers") || []
    @policies = linked("policies")
  end
end
