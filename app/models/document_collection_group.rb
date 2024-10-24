class DocumentCollectionGroup
  attr_reader :title, :documents

  def initialize(collection_group_hash, documents_array)
    @title = collection_group_hash["title"]
    @documents = collection_group_hash["documents"].map do |document_content_id|
      Rails.logger.info("In DocumentCollectionGroup #{@title} Looking for document with ID #{document_content_id}")
      document = documents_array.find { |doc| doc["content_id"] == document_content_id }
      {
        "text" => document["title"],
        "href" => document["base_path"],
      }
    end
    @documents.compact
  end
end
