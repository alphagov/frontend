module Block
  class LayoutBase < Block::Base
    attr_reader :blocks

    def initialize(block_hash)
      super(block_hash)

      @blocks = BlockFactory.build_all(data["blocks"])
    end
  end
end
