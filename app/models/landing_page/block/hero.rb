module LandingPage::Block
  HeroImageSources = Data.define(:desktop, :desktop_2x, :tablet, :tablet_2x, :mobile, :mobile_2x)
  HeroImage = Data.define(:alt, :sources)

  class Hero < Base
    attr_reader :image, :hero_content, :theme

    def initialize(block_hash, landing_page)
      super

      alt, sources = data.fetch("image").values_at("alt", "sources")
      sources = HeroImageSources.new(**sources)
      @image = HeroImage.new(alt:, sources:)
      @hero_content = LandingPage::BlockFactory.build_all(data.dig("hero_content", "blocks"), landing_page)
      @theme = data.fetch("theme", "default")
    end

    def full_width?
      true
    end
  end
end
