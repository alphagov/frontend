module Phases
  extend ActiveSupport::Concern

  def opening_date_time
    content_store_response.dig("details", "opening_date")
  end
end
