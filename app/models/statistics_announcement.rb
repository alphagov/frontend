class StatisticsAnnouncement < ContentItem
  include Updatable

  def release_date
    content_store_response.dig("details", "display_date")
  end
end