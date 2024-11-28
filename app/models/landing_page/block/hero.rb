module LandingPage::Block
  HeroImageSources = Data.define(:desktop, :desktop_2x, :tablet, :tablet_2x, :mobile, :mobile_2x)
  HeroImage = Data.define(:alt, :sources)

  class Hero < Base
    attr_reader :image, :hero_content, :theme, :theme_colour

    def initialize(block_hash, landing_page)
      super

      image_config = data.fetch("image")
      alt = image_config.fetch("alt", "")
      sources = HeroImageSources.new(**image_config.fetch("sources"))
      @image = HeroImage.new(alt:, sources:)
      @hero_content = LandingPage::BlockFactory.build_all(data.dig("hero_content", "blocks"), landing_page)
      @theme = data.fetch("theme", "default")
      @theme_colour = data["theme_colour"]
    end

    def full_width?
      true
    end
  end
end
