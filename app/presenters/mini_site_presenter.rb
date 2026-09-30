class MiniSitePresenter < ContentItemPresenter
  include DocumentFeed
  include ImpactHeader
  include Involved
  include OrderedFeaturedDocuments
  include ServiceNavigation

  def body_with_image?
    content_item.header_image.present? && content_item.logo_image.present?
  end

  def formatted_social_media_links
    content_item.details["social_media_links"].map do |social_media_link|
      {
        href: social_media_link["href"],
        icon: social_media_link["service_type"],
        text: social_media_link["title"],
      }
    end
  end

  def impact_header_image
    [content_item.header_image, content_item.logo_image].find { it }
  end

  def impact_header_image_type
    content_item.header_image.present? ? "header" : "logo"
  end
end
