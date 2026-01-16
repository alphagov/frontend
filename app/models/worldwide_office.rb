class WorldwideOffice < ContentItem
  attr_reader :headers

  def initialize(content_store_response)
    super
    @headers = content_store_response.dig("details", "headers") || []
  end

  def worldwide_organisation
    linked("worldwide_organisation").first
  end

  def contact
    linked("contact").first
  end
end
