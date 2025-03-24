module FlexiblePage
  module FlexibleSection
    class PageTitle
      attr_reader :context, :heading_text, :lead_paragraph

      def initialize(flexible_section_hash, landing_page)
        super

        @context = data["context"]
        @heading_text = data["heading_text"]
        @lead_paragraph = data["lead_paragraph"]
      end
    end
  end
end
