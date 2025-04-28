module FlexiblePage::FlexibleSection
  class Base
    attr_reader :data, :flexible_page, :type

    def initialize(flexible_section_hash, flexible_page)
      @data = flexible_section_hash
      @type = data["type"]
      @flexible_page = flexible_page
    end
  end
end
