module OrderedFeaturedDocuments
  def ordered_featured_documents_for_image_cards
    (content_item.details["ordered_featured_documents"] || []).map do |i|
      {
        description: ActionController::Base.helpers.sanitize(i["summary"]).truncate(160, separator: " "),
        heading_level: 0,
        heading_text: i["title"],
        href: i["href"],
        image_alt: i["image"]["alt_text"],
        image_src: i["image"]["url"],
        margin_bottom: 8,
      }
    end
  end
end
