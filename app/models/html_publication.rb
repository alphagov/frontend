class HtmlPublication < ContentItem
  include Political

  def parent
    linked("parent").first
  end

  def public_timestamp
    content_store_response["details"]["public_timestamp"]
  end

  def first_published_version
    content_store_response.dig("details", "first_published_version")
  end

  def headers
    content_store_response.dig("details", "headers") || []
  end

  def copyright_year
    content_store_response.dig("details", "public_timestamp").to_date.year if public_timestamp.present?
  end

  def isbn
    content_store_response.dig("details", "isbn")
  end
end
