module FlexiblePage::FlexibleSection
  class Base
    attr_reader :content_item, :flexible_section_hash, :type

    def initialize(flexible_section_hash, content_item)
      @content_item = content_item
      @flexible_section_hash = flexible_section_hash
      @type = flexible_section_hash["type"]
    end

    def before_content?
      false
    end
  end
end
