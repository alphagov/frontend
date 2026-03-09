module SpeechNewsImage
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
    { "url" => "https://assets.publishing.service.gov.uk/media/5e59279b86650c53b2cefbfe/placeholder.jpg" }
  end
end
