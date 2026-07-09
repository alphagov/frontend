class History < ContentItem
  include HasImages

  def lead_paragraph
    content_store_response.dig("details", "lead_paragraph")
  end

private

  def contents_list
    (content_store_response.dig("details", "headers") || []).map { |header| header.except("headers").deep_symbolize_keys }
  end
end
