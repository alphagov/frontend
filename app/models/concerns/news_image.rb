module NewsImage
  extend ActiveSupport::Concern

  def image
    content_store_response.dig("details", "image") || default_news_image || placeholder_image
  end

private

  def default_news_image
    organisation = content_store_response.dig("links", "primary_publishing_organisation")
    organisation[0].dig("details", "default_news_image") if organisation.present?
  end

  def placeholder_image
    # this image has been uploaded to asset-manager
    return { "url" => "https://assets.publishing.service.gov.uk/media/5e985599d3bf7f3fc943bbd8/UK_government_logo.jpg" } if content_store_response["document_type"] == "world_news_story"

    { "url" => "https://assets.publishing.service.gov.uk/media/5e59279b86650c53b2cefbfe/placeholder.jpg" }
  end
end
