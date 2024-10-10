module Block
  CardImage = Data.define(:alt, :source)

  class Card < Block::Base
    attr_reader :label, :content, :image, :card_content

    def initialize(block_hash)
      super(block_hash)

      alt, source = data.fetch("image").values_at("alt", "source")
      @image = CardImage.new(alt:, source:)
      @card_content = data.dig("card_content", "blocks")&.map { |subblock_hash| BlockFactory.build(subblock_hash) }
    end
  end
end
