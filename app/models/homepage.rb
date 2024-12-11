class Homepage < ContentItem
  def popular_links
    @popular_links ||= popular_links_data&.collect(&:with_indifferent_access)
  end

private

  def popular_links_data
    @popular_links_data ||= links.dig("popular_links", 0, "details", "link_items")
  end
end
