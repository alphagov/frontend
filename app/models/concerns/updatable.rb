module Updatable
  extend ActiveSupport::Concern

  def published
    first_public_at
  end

  def updated
    public_updated_at if any_updates?
  end

  def history
    return [] unless any_updates?

    reverse_chronological_change_history
  end

private

  def any_updates?
    if public_updated_at && first_public_at
      Time.zone.parse(public_updated_at) != Time.zone.parse(first_public_at)
    else
      false
    end
  end

  # The direction of change history isn't guaranteed
  # https://github.com/alphagov/govuk-content-schemas/issues/545
  def reverse_chronological_change_history
    change_history.sort_by { |item| Time.zone.parse(item[:timestamp]) }.reverse
  end

  def change_history
    changes = content_store_hash.dig("details", "change_history") || []
    changes.map do |item|
      {
        display_time: item["public_timestamp"],
        note: item["note"],
        timestamp: item["public_timestamp"],
      }
    end
  end
end
