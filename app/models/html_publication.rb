class HtmlPublication < ContentItem
  def parent
    linked("parent").first
  end

  def organisations
    linked("organisations")
  end
end
