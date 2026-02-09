module FlexiblePage::FlexibleSection
  class Breadcrumbs < Base
    attr_reader :breadcrumbs

    def initialize(flexible_section_hash, content_item)
      super

      @breadcrumbs = flexible_section_hash["breadcrumbs"].map(&:symbolize_keys)
    end

    def before_content?
      true
    end
  end
end
