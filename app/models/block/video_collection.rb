module Block
  Video = Data.define(:title, :url, :date)

  class VideoCollection < Block::Base
    attr_reader :videos

    def initialize(block_hash)
      super(block_hash)

      @videos = data.fetch("videos", []).map { |video| Video.new(**video) }
    end
  end
end
