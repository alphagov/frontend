class MiniSite < ContentItem
  include EmphasisedOrganisations

  def featured_items
    (details["ordered_featured_documents"] || []).map do |i|
      {
        description: i["summary"],
        heading_text: i["title"],
        href: i["href"],
        image_alt: i["image"]["alt_text"],
        image_src: i["image"]["url"],
      }
    end
  end

  def feed_items
    @feed_items ||= FeedService.new(search_options: { filter_topical_events: base_path.split("/").last }).fetch_related_documents_with_format
  end

  def header_image
    return unless details["images"]

    details["images"].select { |i| i["type"] == "header" }.first&.deep_symbolize_keys
  end

  def logo_image
    return unless details["images"]

    details["images"].select { |i| i["type"] == "logo" }.first&.deep_symbolize_keys
  end

  def ordered_navigation_items
    content_store_response["details"]["ordered_navigation_items"].map { |item|
      navigation_items.find { it.content_id == item["content_id"] }
    }.compact
  end

private

  def navigation_items
    shared_navigations = linked("shared_navigations") || []
    return [] unless shared_navigations.any?

    navigation_items_array = shared_navigations.first.content_store_response["navigation_items"]
    return [] unless navigation_items_array.any?

    navigation_items_array.map { |navigation_items_hash| ContentItemFactory.build(navigation_items_hash) }
  end
end
