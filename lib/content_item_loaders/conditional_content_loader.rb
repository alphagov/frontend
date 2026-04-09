module ContentItemLoaders
  class ConditionalContentLoader
    def initialize(request:)
      @cache = {}
      @request = request
    end

    def load(base_path:)
      @cache[base_path] ||= GovukConditionalContentItemLoader.new(request: @request, base_path:).load
    end
  end
end
