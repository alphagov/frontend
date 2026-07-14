module HasImages
  def images
    @images ||= extract_images
  end

  def image_for(type)
    images.find { it.type == type }
  end

private

  def extract_images
    images_info = content_store_response.dig("details", "images") || []
    images_info.map { |info| Image.new(info) }
  end
end
