module ContentItemLoaders
  class ContentStoreLoader
    def initialize
      @cache = {}
    end

    def load(request)
      content_item_from_conditional_loader(request)
    end

    def load_from_base_path(base_path)
      request = ActionDispatch::Request.new({
        "ORIGINAL_FULLPATH" => base_path,
        "PATH_INFO" => base_path,
        "REQUEST_METHOD" => "GET",
        "REQUEST_PATH" => base_path,
      })

      content_item_from_conditional_loader(request)
    end

  private

    def content_item_from_conditional_loader(request)
      base_path = request.path
      @cache[base_path] ||= GovukConditionalContentItemLoader.new(request: request).load
    end
  end
end
