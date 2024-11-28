module LandingPage::Block
  ImageSources = Data.define(:desktop, :desktop_2x, :tablet, :tablet_2x, :mobile, :mobile_2x)
  ImageData = Data.define(:alt, :sources)

  class Image < Base
    attr_reader :image

    def initialize(block_hash, landing_page)
      super

      if data["image"].present?
        image_config = data.fetch("image")
        alt = image_config.fetch("alt", "")
        sources = image_config.fetch("sources")
        sources = ImageSources.new(**sources)
        @image = ImageData.new(alt:, sources:)
      end
    end

    def full_width?
      data["theme"] == "full_width"
    end
  end
end
