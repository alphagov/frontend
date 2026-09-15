class TopicalEventAboutPage < ContentItem
  def contents_outline
    ContentsOutline.new((content_store_response.dig("details", "headers") || []).map { |header| header.except("headers").deep_symbolize_keys })
  end

  def parent
    linked("parent").first
  end
end
