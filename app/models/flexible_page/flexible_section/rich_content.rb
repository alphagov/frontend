module FlexiblePage::FlexibleSection
  class RichContent < Base
    ContentImage = Data.define(:alt, :src)

    attr_reader :contents_list, :govspeak, :image

    def initialize(flexible_section_hash, flexible_page)
      super

      @contents_list = ContentsOutline.new(data["contents_list"])
      @govspeak = data["govspeak"]

      if data["image"].present?
        alt, src = data.fetch("image").values_at("alt", "src")
        @image = ContentImage.new(alt:, src:)
      end
    end
  end
end
