class Homepage < ContentItem
  def popular_links
    @popular_links ||= popular_links_data.collect(&:with_indifferent_access)
  end

private

  def popular_links_data
    @popular_links_data ||= popular_links_from_content_item || hard_coded_popular_links
  end

  def popular_links_from_content_item
    @popular_links_from_content_item ||= links.dig("popular_links", 0, "details", "link_items")
  end

  def hard_coded_popular_links
    I18n.t("homepage.index.popular_links")
  end
end
