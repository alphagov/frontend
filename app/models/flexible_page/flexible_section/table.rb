module FlexiblePage::FlexibleSection
  class Table < Base
    attr_reader :caption, :data

    def initialize(flexible_section_hash, content_item)
      super

      @caption = flexible_section_hash["caption"]
      @data = flexible_section_hash["data"]
    end

    def hash_for_table_component
      {caption:}.merge(data)
    end
  end
end