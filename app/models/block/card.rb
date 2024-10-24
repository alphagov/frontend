module Block
  CardImage = Data.define(:alt, :source)

  class Card < Block::Base
    attr_reader :image, :card_content

    def initialize(block_hash)
      super(block_hash)

      if data["image"].present?
        alt, source = data.fetch("image").values_at("alt", "source")
        @image = CardImage.new(alt:, source:)
      end

      @card_content = BlockFactory.build_all(data.dig("card_content", "blocks"))
    end
  end
end
