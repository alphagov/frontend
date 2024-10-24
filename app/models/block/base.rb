module Block
  class Base
    attr_reader :id, :type, :data, :landing_page

    def initialize(block_hash, landing_page)
      @data = block_hash
      @id = data["id"]
      @type = data["type"]
      @landing_page = landing_page
    end

    def full_width?
      false
    end
  end
end
