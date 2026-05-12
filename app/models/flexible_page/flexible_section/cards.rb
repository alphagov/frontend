module FlexiblePage::FlexibleSection
  class Cards < Base
    attr_reader :items

    def initialize(items:)
      super

      @items = items
    end
  end
end
