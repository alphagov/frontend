module ContentItemLoaderHelpers
  def clear_content_item_loader_cache
    ContentItemLoader.cache.each_key { |key| ContentItemLoader.cache.delete(key) }
  end
end
