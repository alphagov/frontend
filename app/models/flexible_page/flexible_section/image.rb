module FlexiblePage::FlexibleSection
  class Image < Base
    attr_reader :image

    def initialize(image:)
      super

      @image = image
    end
  end
end
