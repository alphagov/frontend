class ContentItemFactory
  def self.build(content_store_response)
    content_item_class(content_store_response["document_type"]).new(content_store_response)
  end

  def self.content_item_class(document_type)
    klass = document_type.camelize.constantize
    klass.superclass == ContentItem ? klass : ContentItem
  rescue StandardError
    ContentItem
  end
end
