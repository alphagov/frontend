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

    @blocks = BlockFactory.build_all(content_store_hash.dig("details", "blocks"), self)
  end

  def collection_groups
    @collection_groups ||= retrieve_collection_groups
  end

  def parent_collection
    @parent_collection ||= retrieve_parent_collection
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
    linked_documents = content_store_hash.dig("links", "documents") || []
    collection_groups = content_store_hash.dig("details", "collection_groups") || {}

    if !linked_documents.empty? && !collection_groups.empty?
      group_hashable_array = collection_groups.map do |collection_group_hash|
        group = DocumentCollectionGroup.new(
          collection_group_hash,
          linked_documents,
        )
        [group.title, group]
      end
      group_hashable_array.to_h
    else
      {}
    end
  end

  def retrieve_parent_collection
    if content_store_hash.dig("links", "document_collections") in [document_collection]
      return nil unless document_collection["schema_name"] == "landing_page"

      LandingPage.new(GdsApi.content_store.content_item(document_collection["base_path"]))
    else
      nil
    end
  end
end
