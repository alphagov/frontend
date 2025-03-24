class FlexiblePage
  module FlexibleSection
    class PageTitle < Base
      attr_reader :context, :heading_text, :lead_paragraph

      def initialize(flexible_section_hash, flexible_page)
        super

        @context = data["context"]
        @heading_text = data["heading_text"]
        @lead_paragraph = data["lead_paragraph"]
      end
    end
  end
end
