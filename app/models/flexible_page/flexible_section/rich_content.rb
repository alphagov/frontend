class FlexiblePage
  module FlexibleSection
    class RichContent < Base
      attr_reader :contents_list, :govspeak, :image

      def initialize(flexible_section_hash, flexible_page)
        super

        @contents_list = ContentsList.new(data["contents_list"])
        @govspeak = data["govspeak"]
        @image = data["image"]
      end
    end
  end
end
