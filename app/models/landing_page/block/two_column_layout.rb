module LandingPage::Block
  class TwoColumnLayout < LayoutBase
    attr_reader :left, :right, :theme
    alias_method :columns, :blocks

    def initialize(block_hash, landing_page)
      super

      @left = columns[0]
      @right = columns[1]
      @theme = data["theme"]

      if theme == "two_thirds_right"
        @left = nil
        @right = columns[0]
      end
    end

    def left_column_class
      return "govuk-grid-column-one-third" if theme == "one_third_two_thirds"
      return "govuk-grid-column-two-thirds-from-desktop" if theme == "two_thirds_one_third"

      "govuk-grid-column-one-third grid-column-one-third-offset" if theme == "two_thirds_right"
    end

    def right_column_class
      return "govuk-grid-column-two-thirds-from-desktop" if theme == "one_third_two_thirds"
      return "govuk-grid-column-one-third" if theme == "two_thirds_one_third"

      "govuk-grid-column-two-thirds-from-desktop" if theme == "two_thirds_right"
    end
  end
end
