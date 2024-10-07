module Block
  class LayoutBase < Block::Base
    attr_reader :blocks

    def initialize(block_hash)
      super(block_hash)

      @blocks = data["blocks"].map { |subblock_hash| BlockFactory.build(subblock_hash) }
    end
  end
end
