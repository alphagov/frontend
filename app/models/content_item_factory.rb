class ContentItemFactory
  def self.build(content_store_response)
    content_item_class(content_store_response["schema_name"]).new(content_store_response)
  end

  def self.content_item_class(schema_name)
    klass = schema_name.camelize.constantize
    klass.superclass == ContentItem ? klass : ContentItem
  rescue StandardError
    ContentItem
  end
end
