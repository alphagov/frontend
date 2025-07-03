class DocumentCollection < ContentItem
  include Political
  include SinglePageNotificationButton
  include Updatable

  attr_reader :collection_groups, :headers

  CollectionGroup = Data.define(:body, :documents, :id, :title)

  def initialize(content_store_response)
    super

    @collection_groups = content_store_response.dig("details", "collection_groups").map do |group_details|
      CollectionGroup.new(
        body: group_details["body"],
        documents: group_details["documents"].map { |id| linked("documents").find { |d| d.content_id == id } }.compact,
        id: group_details["title"].tr(" ", "-").downcase,
        title: group_details["title"],
      )
    end

    @headers = content_store_response.dig("details", "headers") || []
  end

  def taxonomy_topic_email_override_base_path
    linked("taxonomy_topic_email_override").first&.base_path
  end
end
