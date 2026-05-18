module FlexiblePage::FlexibleSection
  class Breadcrumbs < Base
    attr_reader :breadcrumbs

    def initialize(breadcrumbs:)
      super

      @breadcrumbs = breadcrumbs
    end

    def before_content?
      true
    end
  end
end
