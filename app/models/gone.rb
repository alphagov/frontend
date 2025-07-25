class Gone < ContentItem
  def explanation
    content_store_response.dig("details", "explanation")
  end

  def alternative_path
    content_store_response.dig("details", "alternative_path")
  end
end
