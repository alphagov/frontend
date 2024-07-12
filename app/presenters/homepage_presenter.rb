class HomepagePresenter < ContentItemPresenter
  PASS_THROUGH_KEYS = %i[
    links
  ].freeze

  PASS_THROUGH_KEYS.each do |key|
    define_method key do
      content_item[key.to_s]
    end
  end

  def link_items
    @link_items ||= links.dig("popular_links", 0, "details", "link_items")
  end

  def hardcoded_popular_links
    @hardcoded_popular_links ||= I18n.t("homepage.index.popular_links")
  end

  def popular_links_data
    link_items || hardcoded_popular_links
  end

  def popular_links
    @popular_links ||= popular_links_data.collect(&:with_indifferent_access)
  end
end
