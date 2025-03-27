module FlexiblePage::FlexibleSection
  class RichContent < Base
    ContentImage = Data.define(:alt, :src)

    attr_reader :contents_list, :govspeak, :image

    def initialize(flexible_section_hash, content_item)
      super

      @contents_list = ContentsOutline.new(flexible_section_hash["contents_list"])
      @govspeak = flexible_section_hash["govspeak"]

      if flexible_section_hash["image"].present?
        alt, src = flexible_section_hash.fetch("image").values_at("alt", "src")
        @image = ContentImage.new(alt:, src:)
      end
    end
  end
end
