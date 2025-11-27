class StatisticsAnnouncement < ContentItem
  include Updatable

  def release_date
    content_store_response.dig("details", "display_date")
  end

  def cancelled?
    state == "cancelled"
  end

  private

  def state
    content_store_response["details"]["state"]
  end
end