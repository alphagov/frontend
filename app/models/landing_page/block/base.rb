module LandingPage::Block
  class Base
    attr_reader :id, :data, :landing_page, :type

    def initialize(block_hash, landing_page)
      @data = block_hash
      @id = data["id"]
      @landing_page = landing_page
      @type = data["type"]
    end

    def full_width?
      false
    end

    def full_width_background?
      @data["full_width_background"]
    end
  end
end
