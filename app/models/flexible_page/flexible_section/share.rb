module FlexiblePage::FlexibleSection
  class Share < Base
    attr_reader :heading_text, :links

    def initialize(heading_text:, links:)
      super

      @heading_text = heading_text
      @links = links
    end
  end
end
