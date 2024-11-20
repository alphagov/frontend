module LandingPage::Block
  CardImage = Data.define(:alt, :source)

  class Card < Base
    attr_reader :image, :card_content, :href, :content, :body_content, :link_cover_block, :big_number

    def initialize(block_hash, landing_page)
      super

      @href = data["href"] || ""
      @content = data["content"] || ""
      @body_content = data["body_content"] || ""
      @link_cover_block = data["link_cover_block"] || false
      @big_number = data["big_number"] || {}
      @big_number_preface = data.dig("big_number", "preface") || ""
      @big_number_number = data.dig("big_number", "number") || ""

      if data["image"].present?
        alt, source = data.fetch("image").values_at("alt", "source")
        @image = CardImage.new(alt:, source:)
      end

      @card_content = LandingPage::BlockFactory.build_all(data.dig("card_content", "blocks"), landing_page)
    end
  end
end
