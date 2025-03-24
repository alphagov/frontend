module FlexiblePage
  class FlexibleSectionFactory
    def self.build(flexible_section_hash, flexible_page)
      block_class(flexible_section_hash["type"]).new(flexible_section_hash, flexible_page)
    end

    def self.block_class(type)
      "FlexiblePage::FlexibleSection::#{type.camelize}".constantize
    rescue StandardError
      raise("Couldn't identify a model class for type: #{type}")
    end
  end
end
