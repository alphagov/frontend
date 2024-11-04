module Metadata
  extend ActiveSupport::Concern

  included do
    def publisher_metadata
      metadata = {
        from: linkable_organisations,
        first_published: first_public_at,
        last_updated: updated,
      }

      unless pending_stats_announcement?
        metadata[:see_updates_link] = true
      end

      metadata
    end
  end

private

  def details_display_date
    content_store_hash.dig("details", "display_date")
  end

  def pending_stats_announcement?
    details_display_date.present? && Time.zone.parse(details_display_date).future?
  end

  def linkable_organisations
    organisation_links_with_emphasis + expanded_links("worldwide_organisations")
  end

  def organisation_links_with_emphasis
    expanded_links("organisations").sort_by { |link| emphasised?(link) ? -1 : 1 }
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
end
