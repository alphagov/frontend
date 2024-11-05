module LandingPage::Block
  class Featured < Base
    include LandingPage::Block::Concerns::HasImageSet

    attr_reader :featured_content

    def initialize(block_hash, landing_page)
      super

      @featured_content = data.dig("featured_content", "blocks")&.map { |subblock_hash| LandingPage::BlockFactory.build(subblock_hash, landing_page) }
    end

    def full_width?
      false
    end
  end
end
