module Block
  FeaturedImageSources = Data.define(:desktop, :desktop_2x, :tablet, :tablet_2x, :mobile, :mobile_2x)
  FeaturedImage = Data.define(:alt, :sources)

  class Featured < Block::Base
    attr_reader :image, :featured_content

    def initialize(block_hash, landing_page)
      super

      alt, sources = data.fetch("image").values_at("alt", "sources")
      sources = FeaturedImageSources.new(**sources)
      @image = FeaturedImage.new(alt:, sources:)
      @featured_content = BlockFactory.build_all(data.dig("featured_content", "blocks"), landing_page)
    end

    def full_width?
      false
    end
  end
end
