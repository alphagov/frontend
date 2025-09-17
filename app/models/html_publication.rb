class HtmlPublication < ContentItem
  include Political
  include NationalApplicability

  def parent
    linked("parent").first
  end

  def organisations
    linked("organisations")
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
end
