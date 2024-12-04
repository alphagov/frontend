module LandingPage::Block
  class BlockError < Base
    attr_reader :error

    def initialize(block_hash, landing_page)
      super

      @error = data["error"]
    end
  end
end
