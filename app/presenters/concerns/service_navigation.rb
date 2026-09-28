module ServiceNavigation
  def ordered_navigation_items_for_service_navigation
    content_item.ordered_navigation_items.map do |ordered_navigation_item|
      {
        text: ordered_navigation_item.title,
        href: ordered_navigation_item.base_path,
        active: content_item.base_path == ordered_navigation_item.base_path,
      }
    end
  end
end
