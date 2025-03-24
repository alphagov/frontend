module FlexiblePage::FlexibleSection
  class Base
    attr_reader :data, :type

    def initialize(flexible_section_hash, flexible_page)
      @data = flexible_section_hash
      @type = data["type"]
    end
  end
end
