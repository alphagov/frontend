class FlexiblePage
  module FlexibleSection
    class RichContent < Base
      attr_reader :content_list, :govspeak, :image

      def initialize(flexible_section_hash, flexible_page)
        super

        @content_list = contents_list(data["content_list"])
        @govspeak = data["govspeak"]
        @image = data["image"]
      end

      def contents_list(contents)
        contents.map do |item|
          {
            href: item['href'],
            text: item['text'],
          }
        end
      end
    end
  end
end
