class DocumentCollection < ContentItem
  include Political
  include Updatable
  include Withdrawable

  attr_reader :headers, :groups

  Group = Data.define(:body, :documents, :id, :title)

  def initialize(content_store_response)
    super

    @groups = content_store_response.dig("details", "collection_groups").map do |group_details|
      Group.new(
        body: group_details["body"],
        documents: group_details["documents"].map { |id| linked("documents").find { |d| d.content_id == id } }.compact,
        id: group_details["title"].tr(" ", "-").downcase,
        title: group_details["title"],
      )
    end

    @headers = content_store_response.dig("details", "headers") || []
  end

  def show_email_signup_link?
    false
  end

  def display_single_page_notification_button?
    true
  end

  def groups_with_items
    groups.select { |group| group.documents.any? }
  end
end
