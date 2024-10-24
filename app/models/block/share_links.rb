module Block
  class ShareLinks < Block::Base
    attr_reader :links

    def initialize(block_hash)
      super(block_hash)

      @links = data.fetch("links").map { |l| { href: l["href"], text: l["text"], icon: l["icon"], hidden_text: l["hidden_text"] } }
    end
  end
end
