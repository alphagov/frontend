class ServiceManualTopic < ContentItem
  def groups
    content_store_response.dig("details", "groups")
  end

  def visually_collapsed?
    content_store_response.dig("details", "visually_collapsed")
  end

  def groups_with_links
    topic_groups = Array(groups).map do |group_data|
      {
        name: group_data["name"],
        description: group_data["description"],
        items: content(group_data),
      }
    end
    topic_groups.select(&:present?)
    topic_groups.select { |t| t[:items].present? }
  end

  def content_owners
    linked("content_owners")
  end

private

  def content(group_data)
    documents = group_data["content_ids"].map do |item|
      linked("linked_items").find { |ld| ld.content_id == item }
    end
    documents.select(&:present?)
  end
end
