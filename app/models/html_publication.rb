class HtmlPublication < ContentItem
  def parent
    linked("parent").first
  end
end
