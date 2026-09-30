module ServiceNavigation
  def ordered_navigation_items_for_service_navigation
    all_items = [content_item.root_navigation_item] + content_item.ordered_navigation_items
    all_items.map do |ordered_navigation_item|
      {
        active: content_item.base_path == ordered_navigation_item.base_path,
        href: ordered_navigation_item.base_path,
        text: content_item.base_path == ordered_navigation_item.base_path ? "#{ordered_navigation_item.title} home" : ordered_navigation_item.title,
      }
    end
  end
end
