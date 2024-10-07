module Block
  class TwoColumnLayout < Block::LayoutBase
    attr_reader :left, :right, :theme
    alias_method :columns, :blocks

    def initialize(block_hash)
      super(block_hash)

      @left = columns[0]
      @right = columns[1]
      @theme = data["theme"]
    end

    def left_column_size
      theme == "two_thirds_one_third" ? 2 : 1
    end

    def right_column_size
      theme == "one_third_two_thirds" ? 2 : 1
    end

    def total_columns
      left_column_size + right_column_size
    end
  end
end
