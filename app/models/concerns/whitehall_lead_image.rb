module WhitehallLeadImage
  extend ActiveSupport::Concern

  def image_url
    return unless image

    image.dig("sources", "s300")
  end

  def image
    images = content_store_response.dig("details", "images")

    return nil unless images.is_a?(Array)

    images.find { |image| image["type"] == "lead" }
  end
end
