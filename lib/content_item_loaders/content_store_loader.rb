module ContentItemLoaders
  class ContentStoreLoader
    def initialize
      @cache = {}
    end

    def load(request)
      content_item_from_conditional_loader(request)
    end

    def load_from_base_path(base_path)
      content_item_from_content_store(base_path)
    end

  private

    def content_item_from_content_store(base_path)
      @cache[base_path] ||= GdsApi.content_store.content_item(base_path)
    end

    def content_item_from_conditional_loader(request)
      base_path = request.path
      @cache[base_path] ||= GovukConditionalContentItemLoader.new(request: request).load
    end
  end
end
