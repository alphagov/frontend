module Block
  class BlocksContainer < Block::LayoutBase
    alias_method :children, :blocks
  end
end
