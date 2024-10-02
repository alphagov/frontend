module Block
  class TwoColumnLayout < Block::Base
    attr_reader :left, :right, :theme

    def initialize(block_hash)
      super(block_hash)

      @left = BlockFactory.build(data["left"])
      @right = BlockFactory.build(data["right"])
      @theme = data["theme"]
    end

    def left_class
      return "govuk-grid-column-two-thirds" if theme == "two_thirds_one_third"

      "govuk-grid-column-one-third"
    end

    def right_class
      return "govuk-grid-column-two-thirds" if theme == "one_third_two_thirds"

      "govuk-grid-column-one-third"
    end
  end
end
