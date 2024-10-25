module LandingPage::Block
  class Base
    attr_reader :id, :type, :data

    def initialize(block_hash)
      @data = block_hash
      @id = data["id"]
      @type = data["type"]
    end

    def full_width?
      false
    end
  end
end
