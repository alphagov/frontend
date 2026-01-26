module FlexiblePage::FlexibleSection
  class Organisations < Base
    attr_reader :organisations

    def initialize(flexible_section_hash, content_item)
      super

      @organisations = flexible_section_hash["organisations"]
    end
  end
end
