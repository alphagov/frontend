module FlexiblePage::FlexibleSection
  class Base
    attr_reader :content_item, :flexible_section_hash, :type

    def initialize(flexible_section_hash, content_item)
      @flexible_section_hash = flexible_section_hash
      @content_item = content_item
      set_reader_attributes_from_section_hash
    end

    def set_reader_attributes_from_section_hash
      vars = gather_class_instance_methods(self.class)
      vars.each do |var|
        instance_variable_set("@#{var}", flexible_section_hash[var.to_s])
      end
    end

    def gather_class_instance_methods(from_class)
      methods = from_class.instance_methods(false)
      methods += gather_class_instance_methods(from_class.superclass) unless from_class.name == "FlexiblePage::FlexibleSection::Base"
      methods - %i[content_item flexible_section_hash set_instance_variables gather_class_instance_methods]
    end
  end
end
