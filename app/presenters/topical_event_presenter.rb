class TopicalEventPresenter < ContentItemPresenter
  include DocumentFeed
  include ImpactHeader
  include OrderedFeaturedDocuments

  def about_page_path
    "#{content_item.base_path}/about"
  end

  def body_with_image?
    content_item.header_image.present? && content_item.logo_image.present?
  end

  def impact_header_image
    [content_item.header_image, content_item.logo_image, content_item.legacy_logo].find { it }
  end

  def impact_header_image_type
    content_item.header_image.present? ? "header" : "logo"
  end
end
