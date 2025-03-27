module FlexiblePage::FlexibleSection
  class PageTitle < Base
    attr_reader :context, :heading_text, :lead_paragraph

    def initialize(flexible_section_hash, content_item)
      super

      @context = flexible_section_hash["context"]
      @heading_text = flexible_section_hash["heading_text"]
      @lead_paragraph = flexible_section_hash["lead_paragraph"]
    end
  end
end
