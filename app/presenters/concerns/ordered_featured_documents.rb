module OrderedFeaturedDocuments
  def ordered_featured_documents_for_image_cards
    (details["ordered_featured_documents"] || []).map do |i|
      {
        href: i["href"],
        image_src: i["image"]["url"],
        image_alt: i["image"]["alt_text"],
        heading_text: i["title"],
        description: sanitize(i["summary"]).truncate(160, separator: " "),
      }
    end
  end
end
