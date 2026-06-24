class History < FlexiblePage
  def contents_outline
    ContentsOutline.new((content_store_response.dig("details", "headers") || []).map { |header| header.except("headers").deep_symbolize_keys })
  end

  def lead_paragraph
    content_store_response.dig("details", "lead_paragraph")
  end

private

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
