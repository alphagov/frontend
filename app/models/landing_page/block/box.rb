module LandingPage::Block
  class Box < Base
    attr_reader :box_content, :href, :content

    def initialize(block_hash, landing_page)
      super

      @href = data["href"] || ""
      @content = data["content"] || ""

      @box_content = LandingPage::BlockFactory.build_all(data.dig("box_content", "blocks"), landing_page)
    end
  end
end
