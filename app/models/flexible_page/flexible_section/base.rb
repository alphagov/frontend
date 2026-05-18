module FlexiblePage::FlexibleSection
  class Base
    def initialize(_params); end

    def before_content?
      false
    end

    def type
      self.class.name.split("::").last.underscore
    end
  end
end
