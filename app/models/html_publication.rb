class HtmlPublication < ContentItem
  def parent
    linked("parent").first
  end

  def organisations
    content_store_response.dig("links", "organisations")
  end
end
