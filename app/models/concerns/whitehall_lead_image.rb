module WhitehallLeadImage
  extend ActiveSupport::Concern

  def image
    lead_image_from_details_images || lead_image_from_details_image
  end

  def image_url
    return unless image

    image.dig("sources", "s300") || image["url"]
  end

private

  def lead_image_from_details_images
    images = content_store_response.dig("details", "images")

    return nil unless images.is_a?(Array)

    images.find { |image| image["type"] == "lead" }
  end

  def lead_image_from_details_image
    content_store_response.dig("details", "image")
  end
end
