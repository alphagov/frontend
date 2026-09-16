class TopicalEventPresenter < ContentItemPresenter
  include ImpactHeader

  def body_with_image?
    content_item.header_image && content_item.logo_image
  end

  def impact_header_image
    [content_item.header_image, content_item.logo_image, content_item.legacy_logo].find { it }
  end

  def impact_header_image_type
    content_item.header_image.present? ? "header" : "logo"
  end
end
