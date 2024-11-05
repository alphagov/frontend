module LandingPage::Block
  class Hero < Base
    include LandingPage::Block::Concerns::HasImageSet

    attr_reader :hero_content

    def initialize(block_hash, landing_page)
      super

      @hero_content = LandingPage::BlockFactory.build_all(data.dig("hero_content", "blocks"), landing_page)
    end

    def full_width?
      true
    end
  end
end
