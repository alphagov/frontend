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
        type: "page_title",
        context: "History",
        heading_text: title,
      },
      {
        type: "rich_content",
        contents_list: content_store_response["details"]["headers"].map { |header| header.except("headers") },
        govspeak: body,
        image: {
          alt: content_store_response.dig("details", "sidebar_image", "caption"),
          src: content_store_response.dig("details", "sidebar_image", "url"),
        },
      },
    ]
  end
end
