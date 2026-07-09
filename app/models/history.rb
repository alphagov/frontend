class History < FlexiblePage
  def initialize(content_store_response)
    super

    add_section(Breadcrumbs.new(breadcrumbs: []))
    add_section(PageTitle.new(context: "History", heading_text: title, lead_paragraph:))
    add_section(SidebarThenContentLayout.new(
                  sidebar: RichContentsList.new(contents_list:, image:),
                  content: Govspeak.new(govspeak: body),
                ))
  end

  def lead_paragraph
    content_store_response.dig("details", "lead_paragraph")
  end

private

  def contents_list
    (content_store_response.dig("details", "headers") || []).map { |header| header.except("headers").deep_symbolize_keys }
  end

  def image
    images = content_store_response.dig("details", "images")

    return nil unless images

    sidebar_image = images.find { |image| image["type"] == "sidebar" }

    return nil unless sidebar_image

    {
      alt: sidebar_image["caption"],
      src: sidebar_image.dig("sources", "s960"),
    }
  end
end
