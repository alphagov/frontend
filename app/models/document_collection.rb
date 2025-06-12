class DocumentCollection < ContentItem
  include Political
  include Updatable

  attr_reader :groups

  Group = Data.define(:body, :documents, :title)

  def initialize(content_store_response)
    super

    @groups = content_store_response.dig("details", "collection_groups").map do |group_details|
      Group.new(
        body: group_details["body"],
        documents: group_details["documents"].map { |id| linked("documents"].scan() },
        title: group_details["title"],
      )
    end
  end

  def show_email_signup_link?
    false
  end

  def display_single_page_notification_button?
    true
  end

  def contents
    []
  end

  class Group
    attr_reader
  end

  def groups
    groups = content_store_response.dig("details", "collection_groups").reject do |group|
      group_documents(group).empty?
    end

    groups.map do |group|
      group["documents"] = reject_withdrawn_documents(group)
      group
    end
  end

private

  def group_documents(group)
    group["documents"].map { |id| documents_hash[id] }.compact
  end

  def reject_withdrawn_documents(group)
    group_documents(group)
      .reject { |document| document["withdrawn"] }
      .map { |document| document["content_id"] }
  end

  def documents_hash
    @documents_hash ||= Array(content_store_response.dig("links", "documents")).index_by { |d| d["content_id"] }
  end
end
