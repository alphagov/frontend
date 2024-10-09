class ContentItemFactory
  def self.build(content_store_response)
    content_item_class(
      content_store_response["document_type"],
      content_store_response["schema_name"],
    ).new(content_store_response)
  end

  def self.content_item_class(document_type, schema_name)
    if [document_type, schema_name] in %w[landing_page landing_page]
      LandingPage
    else
      ContentItem
    end
  end
end
