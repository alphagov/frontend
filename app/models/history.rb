class History < ContentItem
  include HasImages

  def contents_outline
    ContentsOutline.new((content_store_response.dig("details", "headers") || []).map { |header| header.except("headers").deep_symbolize_keys })
  end

  def lead_paragraph
    content_store_response.dig("details", "lead_paragraph")
  end
end
