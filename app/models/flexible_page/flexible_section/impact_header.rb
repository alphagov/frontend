module FlexiblePage::FlexibleSection
  class ImpactHeader < Base
    attr_reader :caption, :description, :modifier_classes, :title, :variant

    def initialize(flexible_section_hash, content_item)
      super

      @title = flexible_section_hash["title"]
      @description = flexible_section_hash["description"]
      @variant = flexible_section_hash["variant"] if %w[govuk notable-death].include? flexible_section_hash["variant"]
      @modifier_classes = build_modifier_classes
      @caption = build_caption
    end

    def image
      return false unless flexible_section_hash["image"]

      {
        caption: flexible_section_hash.dig("image", "caption"),
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

  private

    def build_modifier_classes
      base_class = "impact-header"
      logo = flexible_section_hash["image_type"] == "logo"
      return "#{base_class}--plain" unless logo || @variant

      styles = %w[]
      styles << "logo" if logo
      styles << @variant if @variant
      styles << "with-background" if @variant
      styles.map { |s| "#{base_class}--#{s}" }.join(" ")
    end

    def build_caption
      return unless image && image[:caption] && flexible_section_hash["image_type"] != "logo"

      theme = "black" if "--govuk".in?(@modifier_classes) # Enables black text for our blue header.
      inverse = true if "--notable-death".in?(@modifier_classes) # Enables white text for our black header.

      {
        caption_text: image[:caption],
        caption_id: "impact-header__image-id-#{SecureRandom.hex(4)}",
        theme:,
        inverse:,
      }
    end
  end
end
