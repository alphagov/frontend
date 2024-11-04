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
end
