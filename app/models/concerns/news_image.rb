module NewsImage
  extend ActiveSupport::Concern

  def image
    # Case studies do not fall back to a placeholder image
    return content_store_response.dig("details", "image") || default_news_image if content_store_response["document_type"] == "case_study"

    content_store_response.dig("details", "image") || default_news_image || placeholder_image
  end

private

  def default_news_image
    # The primary organisation default news image shows on all subtypes of news articles, on case studies, and on speeches (if a custom image is not set)
    primary_organisation = content_store_response.dig("links", "primary_publishing_organisation")
    primary_org_default_news_image = primary_organisation[0].dig("details", "default_news_image") if primary_organisation.present?

    # News articles additionally fall back to the first organisation or worldwide organisation if the primary publishing organisation does not have a default news image
    document_type = content_store_response["document_type"]
    organisation = content_store_response.dig("links", "organisations")
    organisation_default_news_image = organisation[0].dig("details", "default_news_image") if organisation.present? && is_a_news_article?(document_type)

    # Only world news stories have a worldwide organisation default news image fallback
    worldwide_organisation = content_store_response.dig("links", "worldwide_organisations")
    worldwide_organisation_default_news_image = worldwide_organisation[0].dig("details", "default_news_image") if worldwide_organisation.present? && is_a_news_article?(document_type)

    primary_org_default_news_image || organisation_default_news_image || worldwide_organisation_default_news_image
  end

  def is_a_news_article?(document_type)
    %w[news_story press_release government_response world_news_story].include?(document_type)
  end

  def placeholder_image
    # this image has been uploaded to asset-manager
    return { "url" => "https://assets.publishing.service.gov.uk/media/5e985599d3bf7f3fc943bbd8/UK_government_logo.jpg" } if content_store_response["document_type"] == "world_news_story"

    { "url" => "https://assets.publishing.service.gov.uk/media/5e59279b86650c53b2cefbfe/placeholder.jpg" }
  end
end
