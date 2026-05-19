module FlexiblePage::FlexibleSection
  class Govspeak < Base
    attr_reader :govspeak

    def initialize(govspeak:)
      super

      @govspeak = govspeak
    end
  end
end
