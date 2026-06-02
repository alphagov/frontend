module FlexiblePage::FlexibleSection
  class Breadcrumbs < Base
    attr_reader :breadcrumbs, :margin_bottom, :full_width, :background, :inverse

    def initialize(breadcrumbs:, margin_bottom: nil, full_width: false, background: false)
      super

      @breadcrumbs = breadcrumbs
      @full_width = full_width
      @background = background
      @inverse = true if background
      @margin_bottom = margin_bottom || 8
    end

    def before_content?
      true
    end
  end
end
