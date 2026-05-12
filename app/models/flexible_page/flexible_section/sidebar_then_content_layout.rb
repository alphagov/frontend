module FlexiblePage::FlexibleSection
  class SidebarThenContentLayout < Base
    attr_reader :content, :sidebar

    def initialize(content:, sidebar:)
      super

      @content = content
      @sidebar = sidebar
    end
  end
end
