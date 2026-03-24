module ContentItemLoaders
  class ContentStoreLoader
    def initialize
      @cache = {}
    end

    def load(request)
      base_path = request.path
      content_item_from_content_store(base_path)
    end

    def load_from_base_path(base_path)
      request = ActionDispatch::Request.new({
        "ORIGINAL_FULLPATH" => base_path,
        "PATH_INFO" => base_path,
        "REQUEST_METHOD" => "GET",
        "REQUEST_PATH" => base_path,
      })

      content_item_from_content_store(request)
    end

  private

    def content_item_from_content_store(base_path)
      @cache[base_path] ||= GdsApi.content_store.content_item(base_path)
    end
  end
end
