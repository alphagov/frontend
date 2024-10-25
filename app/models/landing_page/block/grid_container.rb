module LandingPage::Block
  class GridContainer < LayoutBase
    alias_method :children, :blocks
  end
end
