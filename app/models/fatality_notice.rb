class FatalityNotice < ContentItem
  include Updatable

  def field_of_operation
    content_item_links = content_store_hash["links"]["field_of_operation"]
    if content_item_links
      attributes = content_item_links.first
      OpenStruct.new(title: attributes["title"], path: attributes["base_path"])
    end
  end

  def contributors
    organisations_ordered_by_emphasis + links_group(%w[worldwide_organisations people speaker])
  end

private

  def links_group(types)
    types.flat_map { |type| links(type) }.uniq
  end

  def links(type)
    expanded_links_from_content_item(type)
      .select { |link| link["base_path"] }
      .map { |link| { "title" => link["title"], "base_path" => link["base_path"] } }
  end

  def expanded_links_from_content_item(type)
    return [] unless content_store_hash["links"][type]

    content_store_hash["links"][type]
  end
end
