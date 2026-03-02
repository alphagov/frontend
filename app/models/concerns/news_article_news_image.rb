module NewsArticleNewsImage
  extend ActiveSupport::Concern

  # Removed the organisation fallback since that is being sent from whitehall.
  def image_url
    lead_image_from_details_images_url || lead_image_from_details_image_url || placeholder_image_url
  end

private

  def lead_image_from_details_images_url
    images = content_store_response.dig("details", "images")

    return nil unless images.is_a?(Array)

    lead_image = images.find { |image| image["type"] == "lead" }
    lead_image.presence&.dig("sources", "s300")
  end

  # This can be removed after all the news articles are republished, and all the details.images with sources are sent.
  def lead_image_from_details_image_url
    content_store_response.dig("details", "image", "url")
  end

  # We do send a placeholder url from whitehall, but in case something goes wrong, we want to fall back to a placeholder.
  # In the future, this should be configured to not render as default, and only show if the user has opted to show a default.
  # TODO: The generic placeholder image should also be updated to something more intentional.
  def placeholder_image_url
    # this image has been uploaded to asset-manager
    content_store_response["document_type"] == "world_news_story" ? "https://assets.publishing.service.gov.uk/media/5e985599d3bf7f3fc943bbd8/UK_government_logo.jpg" : "https://assets.publishing.service.gov.uk/media/5e59279b86650c53b2cefbfe/placeholder.jpg"
  end
end
