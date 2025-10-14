class TopicalEventAboutPage < FlexiblePage
  def breadcrumbs
    parent = linked("parent").first
    super << {
      title: parent.title,
      url: parent.base_path,
    }
  end

private

  def default_flexible_sections
    [
      {
        type: "page_title",
        heading_text: title,
        lead_paragraph: description,
      },
      {
        type: "rich_content",
        contents_list: (content_store_response.dig("details", "headers") || []).map { |header| header.except("headers") },
        govspeak: body,
      },
    ]
  end
end
