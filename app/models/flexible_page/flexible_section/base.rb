module FlexiblePage::FlexibleSection
  class Base
    attr_reader :flexible_section_hash, :content_item, :type

    def initialize(flexible_section_hash, content_item)
      @flexible_section_hash = flexible_section_hash
      @type = flexible_section_hash["type"]
      @content_item = content_item
    end
  end
end
