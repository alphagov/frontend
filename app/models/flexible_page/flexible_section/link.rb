module FlexiblePage::FlexibleSection
  class Link < Base
    attr_reader :link, :link_text

    def initialize(link:, link_text:)
      super

      @link = link
      @link_text = link_text
    end
  end
end
