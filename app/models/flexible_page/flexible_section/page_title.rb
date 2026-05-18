module FlexiblePage::FlexibleSection
  class PageTitle < Base
    attr_reader :context, :heading_text, :lead_paragraph

    def initialize(heading_text:, context: nil, lead_paragraph: nil)
      super

      @context = context
      @heading_text = heading_text
      @lead_paragraph = lead_paragraph
    end
  end
end
