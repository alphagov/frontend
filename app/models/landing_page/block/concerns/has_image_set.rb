require "ostruct"

module LandingPage::Block::Concerns
  module HasImageSet
    FeaturedImage = Data.define(:alt, :sources)

    def image
      @image ||= load_image
    end

    def load_image
      FeaturedImage.new(alt: data["image"]["alt"], sources: OpenStruct.new(data["image"]["sources"]))
    end
  end
end
