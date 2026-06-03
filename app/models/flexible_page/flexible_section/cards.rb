module FlexiblePage::FlexibleSection
  class Cards < Base
    attr_reader :items

    def initialize(items:, heading_level: nil)
      super

      @items = items
      @heading_level = [2, 3, 4, 5, 6].include?(heading_level) ? heading_level : 2
    end

    def heading
      "h#{@heading_level}"
    end
  end
end
