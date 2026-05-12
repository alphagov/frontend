module FlexiblePage::FlexibleSection
  class ContentThenSidebarLayout < Base
    attr_reader :content, :sidebar

    def initialize(content:, sidebar:)
      super

      @content = content
      @sidebar = sidebar
    end
  end
end
