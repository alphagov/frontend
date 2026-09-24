module Involved
  def organisation_data_for_components
    content_item.organisations_ordered_by_emphasis.map do |org|
      if org.content_store_response.dig("details", "logo", "image")
        image = {
          alt_text: org.content_store_response.dig("details", "logo", "image", "alt_text"),
          url: org.content_store_response.dig("details", "logo", "image", "url"),
        }
      end

      {
        brand: org.brand,
        crest: org.logo.crest,
        image: image,
        name: org.title,
        url: org.content_store_response["web_url"],
      }
    end
  end
end
