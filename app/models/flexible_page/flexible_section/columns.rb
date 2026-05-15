module FlexiblePage::FlexibleSection
  class Columns < Base
    attr_reader :items, :grid_size

    def initialize(flexible_section_hash, content_item)
      super

      @items = flexible_section_hash["items"]
    end
  end
end
