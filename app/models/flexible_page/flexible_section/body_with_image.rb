module FlexiblePage::FlexibleSection
  class BodyWithImage < Base
    attr_reader :govspeak

    def initialize(flexible_section_hash, content_item)
      super

      @govspeak = flexible_section_hash["govspeak"]
    end

    def image
      return nil unless flexible_section_hash["image"]

      {
        sources: {
          desktop: flexible_section_hash.dig("image", "sources", "desktop"),
          desktop_2x: flexible_section_hash.dig("image", "sources", "desktop_2x"),
          tablet: flexible_section_hash.dig("image", "sources", "tablet"),
          tablet_2x: flexible_section_hash.dig("image", "sources", "tablet_2x"),
          mobile: flexible_section_hash.dig("image", "sources", "mobile"),
          mobile_2x: flexible_section_hash.dig("image", "sources", "mobile_2x"),
        },
      }
    end
  end
end
