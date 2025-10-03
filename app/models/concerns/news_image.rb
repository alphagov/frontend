module NewsImage
  extend ActiveSupport::Concern

  def image
    content_store_response.dig("details", "image") || default_news_image || placeholder_image
  end

private

  def default_news_image
    primary_organisation = content_store_response.dig("links", "primary_publishing_organisation")
    primary_org_default_news_image = primary_organisation[0].dig("details", "default_news_image") if primary_organisation.present?

    organisation = content_store_response.dig("links", "organisations")
    organisation_default_news_image = organisation[0].dig("details", "default_news_image") if organisation.present?

    worldwide_organisation = content_store_response.dig("links", "worldwide_organisations")
    worldwide_organisation_default_news_image = worldwide_organisation[0].dig("details", "default_news_image") if worldwide_organisation.present?

    primary_org_default_news_image || organisation_default_news_image || worldwide_organisation_default_news_image
  end

  def placeholder_image
    # this image has been uploaded to asset-manager
    return { "url" => "https://assets.publishing.service.gov.uk/media/5e985599d3bf7f3fc943bbd8/UK_government_logo.jpg" } if content_store_response["document_type"] == "world_news_story"

    { "url" => "https://assets.publishing.service.gov.uk/media/5e59279b86650c53b2cefbfe/placeholder.jpg" }
  end
end
