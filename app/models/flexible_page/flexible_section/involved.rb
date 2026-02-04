module FlexiblePage::FlexibleSection
  class Involved < Base
    def organisations
      format_data_for_components
    end

  private

    def format_data_for_components
      flexible_section_hash["organisations"].map do |org|
        if org.dig("details", "logo", "image")
          image = {
            url: org.dig("details", "logo", "image", "url"),
            alt_text: org.dig("details", "logo", "image", "alt_text"),
          }
        end
        {
          name: org["title"],
          url: org["web_url"],
          crest: org.dig("details", "logo", "crest"),
          brand: org["details"]["brand"],
          image: image,
        }
      end
    end
  end
end
