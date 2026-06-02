module FlexiblePage::FlexibleSection
  class Involved < Base
    attr_reader :organisations, :heading

    def initialize(organisations:, heading: nil)
      super

      @organisations = organisations
      @heading = heading
    end

    def organisation_data_for_components
      organisations.map do |org|
        if org.content_store_response.dig("details", "logo", "image")
          image = {
            url: org.content_store_response.dig("details", "logo", "image", "url"),
            alt_text: org.content_store_response.dig("details", "logo", "image", "alt_text"),
          }
        end
        {
          name: org.title,
          url: org.content_store_response["web_url"],
          crest: org.logo.crest,
          brand: org.brand,
          image: image,
        }
      end
    end
  end
end
