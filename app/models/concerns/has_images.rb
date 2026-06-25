module HasImages
  def image(type, default: false)
    image = images.find { it.type == type }
    return image if image
    return images.find { it.type == "default" } if default

    nil
  end

  def images
    @images ||= extract_images
  end

  def extract_images
    images_info = content_store_response.dig("details", "images")
    images = images_info.map { |info| Image.new(info) } if images_info.is_a?(Array)

    single_image_info = content_store_response.dig("details", "image")
    if single_image_info
      images << Image.new(content_store_response.dig("details", "image").merge("type" => "default"))
    end

    images
  end
end
