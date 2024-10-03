module Block
  class Image < Base
    attr_reader :alt, :src

    def initialize(block_hash)
      super(block_hash)

      @alt = block_hash["alt"]
      @src = block_hash["src"]
    end
  end
end
