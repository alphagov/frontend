module Updatable
  extend ActiveSupport::Concern

  included do
    def updated
      public_updated_at if any_updates?
    end

    def history
      return [] unless any_updates?

      reverse_chronological_change_history
    end

    def initial_publication_date
      first_public_at || first_published_at
    end
  end

private

  def any_updates?
    if public_updated_at && initial_publication_date
      Time.zone.parse(public_updated_at) != Time.zone.parse(initial_publication_date)
    else
      false
    end
  end

  def reverse_chronological_change_history
    change_history.sort_by { |item| Time.zone.parse(item[:timestamp]) }.reverse
  end

  def change_history
    changes = content_store_response.dig("details", "change_history") || []
    changes.map do |item|
      {
        display_time: item["public_timestamp"],
        note: item["note"],
        timestamp: item["public_timestamp"],
      }
    end
  end
end
