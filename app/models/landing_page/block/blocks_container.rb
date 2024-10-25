module LandingPage::Block
  class BlocksContainer < LayoutBase
    alias_method :children, :blocks
  end
end
