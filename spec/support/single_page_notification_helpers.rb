module SinglePageNotificationHelpers
  def single_page_notification_button_ga4_tracking(index_link, section)
    {
      "event_name" => "navigation",
      "type" => "subscribe",
      "index_link" => index_link,
      "index_total" => 2,
      "section" => section,
      "url" => "/email/subscriptions/single-page/new",
    }
  end
end
