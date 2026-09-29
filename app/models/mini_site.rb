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
end
