class ContentItemFactory
  def self.build(content_hash)
    content_item_class(content_hash["document_type"]).new(content_hash)
  end

  def self.content_item_class(document_type)
    klass = document_type.camelize.constantize
    klass.superclass == ContentItem ? klass : ContentItem
  rescue StandardError
    ContentItem
  end
end
