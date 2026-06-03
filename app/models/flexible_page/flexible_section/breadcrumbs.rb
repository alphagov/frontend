module FlexiblePage::FlexibleSection
  class Breadcrumbs < Base
    attr_reader :breadcrumbs_options, :full_width, :background

    def initialize(breadcrumbs_options: {}, full_width: false, background: false)
      super

      @full_width = full_width
      @background = background

      @breadcrumbs_options = {
        collapse_on_mobile: true,
        inverse: (true if background),
        margin_bottom: 8,
      }.merge(breadcrumbs_options).compact
    end

    def before_content?
      true
    end
  end
end
