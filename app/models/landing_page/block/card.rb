module LandingPage::Block
  CardImage = Data.define(:alt, :source)

  class Card < Base
    attr_reader :image, :card_content, :href, :content

    def initialize(block_hash, landing_page)
      super

      @href = data["href"] || ""
      @content = data["content"] || ""

      if data["image"].present?
        alt, source = data.fetch("image").values_at("alt", "source")
        @image = CardImage.new(alt:, source:)
      end

      @card_content = LandingPage::BlockFactory.build_all(data.dig("card_content", "blocks"), landing_page)
    end
  end
end
