module FlexiblePage::FlexibleSection
  class Navigation < Base
    attr_reader :items

    def initialize(items:)
      super

      @items = items
    end

    def before_content
      false
    end
  end
end
