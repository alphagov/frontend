module FlexiblePage::FlexibleSection
  class RichContentsList < Base
    ContentImage = Data.define(:alt, :src)

    attr_reader :contents_list, :image

    def initialize(contents_list:, image: nil)
      super

      @contents_list = ContentsOutline.new(contents_list || [])

      if image.present?
        alt, src = image.values_at(:alt, :src)
        @image = ContentImage.new(alt:, src:)
      end
    end
  end
end
