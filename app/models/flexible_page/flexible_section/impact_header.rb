module FlexiblePage::FlexibleSection
  class ImpactHeader < Base
    attr_reader :breadcrumbs, :description, :title

    def initialize(flexible_section_hash, content_item)
      super

      @title = flexible_section_hash["title"]
      @description = flexible_section_hash["description"]
      @breadcrumbs = flexible_section_hash["breadcrumbs"].map(&:symbolize_keys)
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
      }
    end

    def legacy?
      flexible_section_hash["legacy"]
    end

    def before_content?
      true
    end
  end
end
