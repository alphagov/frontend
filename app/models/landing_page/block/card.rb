module LandingPage::Block
  CardImage = Data.define(:alt, :source)

  class Card < Base
    attr_reader :image, :card_content, :href, :content, :link_cover_block

    def initialize(block_hash)
      super(block_hash)

      @href = data["href"] || ""
      @content = data["content"] || ""
      @link_cover_block = data["link_cover_block"] || false

      if data["image"].present?
        alt, source = data.fetch("image").values_at("alt", "source")
        @image = CardImage.new(alt:, source:)
      end

      @card_content = LandingPage::BlockFactory.build_all(data.dig("card_content", "blocks"))
    end
  end
end
