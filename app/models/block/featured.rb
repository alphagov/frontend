module Block
  FeaturedImageSources = Data.define(:desktop, :desktop_2x, :tablet, :tablet_2x, :mobile, :mobile_2x)
  FeaturedImage = Data.define(:alt, :sources)

  class Featured < Block::Base
    attr_reader :image, :featured_content

    def initialize(block_hash)
      super(block_hash)

      alt, sources = data.fetch("image").values_at("alt", "sources")
      sources = FeaturedImageSources.new(**sources)
      @image = FeaturedImage.new(alt:, sources:)
      @featured_content = data.dig("featured_content", "blocks")&.map { |subblock_hash| BlockFactory.build(subblock_hash) }
    end

    def full_width?
      false
    end
  end
end
