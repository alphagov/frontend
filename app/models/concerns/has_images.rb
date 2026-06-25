module HasImages
  def image(type, default: false)
    image = images.find { it.type == type }
    return image if image
    return images.find { it.type == "default" } if default

    nil
  end

  def default_image
  end

  def images
    @images ||= extract_images
  end

  def extract_images
    images_info = content_store_response.dig("details", "images")
    images_info.map { |info| Image.new(info) } if images_info.is_a?(Array)

    default_image = Image.new(info)
    content_store_response.dig("details", "image")
  end
end
