module Block
  HeroImageSources = Data.define(:desktop, :desktop_2x, :tablet, :tablet_2x, :mobile, :mobile_2x)
  HeroImage = Data.define(:alt, :sources)

  class Hero < Block::Base
    attr_reader :image, :hero_content

    def initialize(block_hash)
      super(block_hash)

      alt, sources = block_hash.fetch("image").values_at("alt", "sources")
      sources = HeroImageSources.new(**sources)
      @image = HeroImage.new(alt:, sources:)
      @hero_content = block_hash.dig("hero_content", "blocks")&.map { |subblock_hash| BlockFactory.build(subblock_hash) }
    end

    def full_width?
      true
    end
  end
end
