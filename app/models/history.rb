class History < FlexiblePage
  def breadcrumbs
    super << {
      title: "History of the UK Government",
      url: "/government/history",
    }
  end

private

  def default_flexible_sections
    [
      {
        type: "breadcrumbs",
        breadcrumbs:,
      },
      {
        type: "page_title",
        context: "History",
        heading_text: title,
        lead_paragraph: content_store_response.dig("details", "lead_paragraph"),
      },
      {
        type: "rich_content",
        contents_list: (content_store_response.dig("details", "headers") || []).map { |header| header.except("headers") },
        govspeak: body,
        image: image_hash,
      },
    ]
  end

  def image_hash
    sidebar_image = sidebar_image_from_details_images || content_store_response.dig("details", "sidebar_image")
    return nil unless sidebar_image

    {
      alt: sidebar_image["caption"],
      src: sidebar_image["url"],
    }
  end

  def sidebar_image_from_details_images
    images = content_store_response.dig("details", "images")
    return nil unless images.is_a?(Array)

    images.find { |image| image["type"] == "sidebar" }
  end
end
