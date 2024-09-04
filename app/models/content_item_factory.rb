class ContentItemFactory
  def self.build(content_hash)
    content_item_class(content_hash).new(content_hash)
  end

  def self.content_item_class(_content_hash)
    ContentItem
  end
end
