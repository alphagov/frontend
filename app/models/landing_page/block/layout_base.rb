module LandingPage::Block
  class LayoutBase < Base
    attr_reader :blocks

    def initialize(block_hash)
      super(block_hash)

      @blocks = LandingPage::BlockFactory.build_all(data["blocks"])
    end
  end
end
