module FlexiblePage::FlexibleSection
  class Link < Base
    attr_reader :link, :link_text

    def initialize(flexible_section_hash, content_item)
      super

      @link = flexible_section_hash["link"]
      @link_text = flexible_section_hash["link_text"]
    end
  end
end
