module FlexiblePage::FlexibleSection
  class ImpactHeader < Base
    attr_reader :description, :title, :variant

    def initialize(flexible_section_hash, content_item)
      super

      @title = flexible_section_hash["title"]
      @description = flexible_section_hash["description"]
      @variant = flexible_section_hash["variant"] if %w[govuk bridges].include? flexible_section_hash["variant"]
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

    def modifier_classes
      base_class = "impact-header"
      logo = flexible_section_hash["image_type"]&.to_sym == :logo
      return "#{base_class}--plain" unless logo || @variant

      styles = %w[]
      styles << "logo" if logo
      styles << @variant if @variant
      styles << "with-background" if @variant
      styles << "grid" unless image
      styles.map { |s| "#{base_class}--#{s}" }.join(" ")
    end
  end
end
