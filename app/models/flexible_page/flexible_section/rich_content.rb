class FlexiblePage
  module FlexibleSection
    class RichContent < Base
      attr_reader :content_list, :govspeak

      def initialize(flexible_section_hash, flexible_page)
        super

        @content_list = data["content_list"]
        @govspeak = data["govspeak"]
      end
    end
  end
end
