module LandingPage::Block
  class LayoutBase < Base
    attr_reader :blocks

    def initialize(block_hash, landing_page)
      super

      @blocks = LandingPage::BlockFactory.build_all(data["blocks"], landing_page)
    end
  end
end
