module LandingPage::Block
  class MainNavigation < Base
    attr_reader :title, :title_link, :links

    def initialize(block_hash)
      super(block_hash)

      @title = data.fetch("title")
      @title_link = data.fetch("title_link")
      @links = data.fetch("links")
    end

    def full_width?
      true
    end
  end
end
