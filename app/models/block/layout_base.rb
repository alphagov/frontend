module Block
  class LayoutBase < Block::Base
    attr_reader :blocks

    def initialize(block_hash, landing_page)
      super

      @blocks = BlockFactory.build_all(data["blocks"], landing_page)
    end
  end
end
