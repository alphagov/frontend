module ImpactHeader
  def image_header_options
    {
      heading: content_item.title,
      description: content_item.description,
      image: build_image(content_item.impact_header_image),
      image_type: content_item.impact_header_image_type,
      variant: notable_death? ? "notable-death" : "plain",
    }
  end

private

  def build_image(image_hash)
    return nil unless image_hash

    {
      caption: image_hash[:caption],
      sources: {
        desktop: image_hash.dig(:sources, :desktop),
        desktop_2x: image_hash.dig(:sources, :desktop_2x),
        tablet: image_hash.dig(:sources, :tablet),
        tablet_2x: image_hash.dig(:sources, :tablet_2x),
        mobile: image_hash.dig(:sources, :mobile),
        mobile_2x: image_hash.dig(:sources, :mobile_2x),
      },
    }
  end

  def notable_death?
    content_item.linked("taxons").find { |taxon| taxon.base_path == "/society-and-culture/notable-death" }.present?
  end
end
