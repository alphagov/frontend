module Block
  class GridContainer < Block::LayoutBase
    alias_method :children, :blocks
  end
end
