require "uri"

class Gone < ContentItem
  def explanation
    content_store_response.dig("details", "explanation")
  end

  def alternative_path
    content_store_response.dig("details", "alternative_path")
  end

  def archived?
    return unless alternative_path

    URI.parse(alternative_path).host == "webarchive.nationalarchives.gov.uk"
  rescue URI::InvalidURIError
    false
  end
end
