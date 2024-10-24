class LandingPage < ContentItem
  attr_reader :blocks

  ADDITIONAL_CONTENT_PATH = "lib/data/landing_page_content_items".freeze

  def initialize(content_store_response)
    if content_store_response.dig("details", "blocks")
      super(content_store_response)
    else
      super(
        content_store_response,
        override_content_store_hash: load_additional_content(content_store_response)
      )
    end

    @blocks = (content_store_hash.dig("details", "blocks") || []).map { |block_hash| BlockFactory.build(block_hash, self) }
  end

  def collection_groups
    @collection_groups ||= retrieve_collection_groups
  end

private

  # SCAFFOLDING: can be removed (and reference above) when full content items
  # including block details are available from content-store
  def load_additional_content(content_store_response)
    base_path = content_store_response["base_path"]
    file_slug = base_path.split("/").last.gsub("-", "_")
    filename = Rails.root.join("#{ADDITIONAL_CONTENT_PATH}/#{file_slug}.yaml")
    content_hash = content_store_response.to_hash
    return content_hash unless File.exist?(filename)

    content_hash.deep_merge(
      "details" => YAML.load_file(filename),
    )
  end

  def retrieve_collection_groups
    if content_store_hash.dig("links", "documents")
      group_hashable_array = (content_store_hash.dig("details", "collection_groups") || {}).map do |collection_group_hash|
        group = DocumentCollectionGroup.new(
          collection_group_hash,
          content_store_hash.dig("links", "documents"),
        )
        [group.title, group]
      end
      group_hashable_array.to_h
    else
      # This is a sub-page, pointing to another page which is the actual document collection
      # We need to load _that_ content item, and copy its collection_groups value
      landing_page_source = ContentItemFactory.build(GdsApi.content_store.content_item(content_store_hash.dig("links", "document_collections").first["base_path"]))
      landing_page_source.collection_groups
    end
  end
end
