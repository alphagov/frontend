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
    extracted_images = images_info.map { |info| Image.new(info) }

    return extracted_images unless details["image"]

    extracted_images << legacy_image

    extracted_images
  end

  def legacy_image
    Image.new({
      alt: details["image"]["alt_text"],
      "sources" => {
        "desktop" => details["image"]["high_resolution_url"],
        "desktop_2x" => nil,
        "tablet" => details["image"]["medium_resolution_url"],
        "tablet_2x" => nil,
        "mobile" => details["image"]["medium_resolution_url"],
        "mobile_2x" => nil,
      },
      "type" => "legacy",
    })
  end
end
