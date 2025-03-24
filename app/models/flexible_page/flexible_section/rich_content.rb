module FlexiblePage
  module FlexibleSection
    class RichContent
      attr_reader :content_list, :govspeak

      def initialize(flexible_section_hash, landing_page)
        super

        @content_list = data["content_list"]
        @govspeak = data["govspeak"]
      end
    end
  end
end
