module ManualUpdates
  extend ActiveSupport::Concern

  def change_notes
    content_store_response.dig("details", "change_notes") || []
  end
end
