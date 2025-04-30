class FlexiblePage::FlexibleSectionFactory
  def self.build(flexible_section_hash, content_item)
    section_class(flexible_section_hash["type"]).new(flexible_section_hash, content_item)
  end

  def self.section_class(type)
    "FlexiblePage::FlexibleSection::#{type.camelize}".constantize
  rescue StandardError
    raise("Couldn't identify a model class for type: #{type}")
  end
end
