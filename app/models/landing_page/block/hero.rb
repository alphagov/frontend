module LandingPage::Block
  HeroImageSources = Data.define(:desktop, :desktop_2x, :tablet, :tablet_2x, :mobile, :mobile_2x)
  HeroImage = Data.define(:alt, :sources)

  class Hero < Base
    attr_reader :image, :theme, :theme_colour

    def initialize(block_hash, landing_page)
      super

      alt, sources = data.fetch("image").values_at("alt", "sources")
      sources = HeroImageSources.new(**sources)
      @image = HeroImage.new(alt:, sources:)
      @theme = data.fetch("theme", "default")
      @theme_colour = data["theme_colour"]
    end

    def full_width?
      true
    end

    def hero_content
      @hero_content ||= begin
        block_content = data.dig("hero_content", "blocks")
        return if block_content.blank?

        LandingPage::BlockFactory.build_all(block_content, landing_page)
      end
    end
  end
end
