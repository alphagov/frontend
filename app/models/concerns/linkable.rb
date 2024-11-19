module Linkable
  extend ActiveSupport::Concern

  def from
    organisations_ordered_by_importance + links_group(%w[worldwide_organisations people speaker])
  end

private

  def organisations_ordered_by_importance
    organisations_with_emphasised_first.map do |link|
      ActionController::Base.helpers.link_to(link["title"], link["base_path"], class: "govuk-link")
    end
  end

  def links(type)
    expanded_links_from_content_item(type)
      .select { |link| link["base_path"] || type == "world_locations" }
      .map { |link| link_for_type(type, link) }
  end

  def organisations_with_emphasised_first
    expanded_links_from_content_item("organisations").sort_by do |organisation|
      is_emphasised = organisation["content_id"].in?(emphasised_organisations)
      is_emphasised ? -1 : 1
    end
  end

  def expanded_links_from_content_item(type)
    return [] unless content_store_hash.dig("links", type)

    content_store_hash.dig("links", type)
  end

  def emphasised_organisations
    content_store_hash.dig("details", "emphasised_organisations") || []
  end

  def links_group(types)
    types.flat_map { |type| links(type) }.uniq
  end

  def link_for_type(_type, link)
    ActionController::Base.helpers.link_to(link["title"], link["base_path"], class: "govuk-link")
  end
end
