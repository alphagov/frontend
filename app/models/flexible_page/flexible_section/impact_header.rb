module FlexiblePage::FlexibleSection
  class ImpactHeader < Base
    attr_reader :caption, :description, :image, :modifier_classes, :title, :variant

    def initialize(description:, title:, image: nil, image_type: :header, variant: nil)
      super

      @description = description
      @title = title
      @variant = variant if %i[govuk notable_death].include? variant

      @image = build_image(image)
      @modifier_classes = build_modifier_classes(image_type)
      @caption = build_caption(image_type)
    end

  private

    def build_image(image_hash)
      return nil unless image_hash

      {
        caption: image_hash[:caption],
        sources: {
          desktop: image_hash.dig(:sources, :desktop),
          desktop_2x: image_hash.dig(:sources, :desktop_2x),
          tablet: image_hash.dig(:sources, :tablet),
          tablet_2x: image_hash.dig(:sources, :tablet_2x),
          mobile: image_hash.dig(:sources, :mobile),
          mobile_2x: image_hash.dig(:sources, :mobile_2x),
        },
      }
    end

    def build_modifier_classes(image_type)
      base_class = "impact-header"
      logo = image_type == :logo
      return "#{base_class}--plain" unless logo || variant

      styles = %w[]
      styles << "logo" if logo
      styles << variant.to_s.gsub("_", "-") if variant
      styles << "with-background" if variant
      styles.map { |s| "#{base_class}--#{s}" }.join(" ")
    end

    def build_caption(image_type)
      return unless image && image[:caption].present? && image_type != :logo

      theme = "black" if "--govuk".in?(modifier_classes) # Enables black text for our blue header.
      inverse = true if "--notable-death".in?(modifier_classes) # Enables white text for our black header.

      {
        caption_text: image[:caption],
        theme:,
        inverse:,
      }
    end
  end
end
