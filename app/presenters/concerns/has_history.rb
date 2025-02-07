module HasHistory
  extend ActiveSupport::Concern

  included do
    include DateHelper

    def history
      return [] unless content_item.any_updates?

      reverse_chronological_change_history
    end
  end

private

  def reverse_chronological_change_history
    changes.sort_by { |item| Time.zone.parse(item[:timestamp]) }.reverse
  end

  def changes
    content_item.change_history.map do |item|
      {
        display_time: view_context.display_date(item["public_timestamp"]),
        note: item["note"],
        timestamp: item["public_timestamp"],
      }
    end
  end
end
