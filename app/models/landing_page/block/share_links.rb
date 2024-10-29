module LandingPage::Block
  class ShareLinks < Base
    attr_reader :links

    def initialize(block_hash, landing_page)
      super

      @links = data.fetch("links").map { |l| { href: l["href"], text: l["text"], icon: l["icon"], hidden_text: l["hidden_text"] } }
    end
  end
end
