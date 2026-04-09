module FlexiblePage::FlexibleSection
  class Table < Base
    attr_reader :caption, :data, :title

    def initialize(flexible_section_hash, content_item)
      super

      @title = flexible_section_hash["title"]
      @caption = flexible_section_hash["caption"]
      @data = flexible_section_hash["data"].deep_symbolize_keys
    end

    def hash_for_table_component
      {caption:}.merge(data)
    end
  end
end