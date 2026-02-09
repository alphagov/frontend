module FlexiblePage::FlexibleSection
  class ImpactHeader < Base
    attr_reader :title, :description

    def initialize(flexible_section_hash, content_item)
      super

      @title = flexible_section_hash["title"]
      @description = flexible_section_hash["description"]
    end

    def image
      return false unless flexible_section_hash["image"]

      {
        sources: {
          desktop: flexible_section_hash.dig("image", "sources", "desktop"),
          desktop_2x: flexible_section_hash.dig("image", "sources", "desktop_2x"),
          tablet: flexible_section_hash.dig("image", "sources", "tablet"),
          tablet_2x: flexible_section_hash.dig("image", "sources", "tablet_2x"),
          mobile: flexible_section_hash.dig("image", "sources", "mobile"),
          mobile_2x: flexible_section_hash.dig("image", "sources", "mobile_2x"),
        },
        alt_text: flexible_section_hash.dig("image", "alt_text"),
      }
    end

    def before_content?
      true
    end
  end
end
