module Linkable
  extend ActiveSupport::Concern

  included do
    def linkable_organisations
      organisations_with_emphasised_first + links_group(%w[worldwide_organisations people speaker])
    end
  end

private

  def organisations_with_emphasised_first
    links_with_emphasis("organisations")
  end

  def links(type)
    expanded_links(type).map { |link| link_to_organisation(link) }
  end

  def links_with_emphasis(type)
    expanded_links(type).sort_by { |link| emphasised?(link) ? -1 : 1 }
                        .map { |link| link_to_organisation(link) }
  end

  def expanded_links(type)
    content_store_hash.dig("links", type) || []
  end

  def emphasised?(link)
    link["content_id"].in?(emphasised_organisations)
  end

  def emphasised_organisations
    content_store_hash.dig("details", "emphasised_organisations") || []
  end

  def links_group(types)
    types.flat_map { |type| links(type) }.uniq
  end

  def link_to_organisation(link)
    ActionController::Base.helpers.link_to(link["title"], link["base_path"], class: "govuk-link")
  end
end
