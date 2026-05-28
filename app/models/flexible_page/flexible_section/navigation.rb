module FlexiblePage::FlexibleSection
  class Navigation < Base
    attr_reader :text, :url

    def initialize(text:, url:)
      super

      @text = text
      @url = url
    end

    def before_content
      false
    end
  end
end
