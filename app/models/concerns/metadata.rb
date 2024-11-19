module Metadata
  extend ActiveSupport::Concern

  def details_display_date
    content_store_hash.dig("details", "display_date")
  end

  def pending_stats_announcement?
    details_display_date.present? && Time.zone.parse(details_display_date).future?
  end

  def publisher_metadata
    metadata = {
      from:,
      first_published: first_published_at,
      last_updated: updated,
    }

    unless pending_stats_announcement?
      metadata[:see_updates_link] = true
    end

    metadata
  end
end
