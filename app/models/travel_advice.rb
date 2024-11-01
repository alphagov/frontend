class TravelAdvice < ContentItem
  ALERT_STATUSES = %w[
    avoid_all_but_essential_travel_to_parts
    avoid_all_travel_to_parts
    avoid_all_but_essential_travel_to_whole_country
    avoid_all_travel_to_whole_country
  ].freeze

  def country_name
    content_store_response["details"]["country"]["name"]
  end

  def map
    content_store_response["details"]["image"]
  end

  def map_download_url
    content_store_response["details"].dig("document", "url")
  end

  def email_signup_link
    content_store_response["details"]["email_signup_link"]
  end

  # Deprecated feature
  # Exists in travel advice publisher but isn't used by FCDO
  # Feature included as it _could_ still be used
  # Remove when alert status boxes no longer in travel advice publisher
  def alert_status
    alert_statuses = content_store_response["details"]["alert_status"]
    return [] if alert_statuses.blank?

    alert_statuses.filter_map { |alert| alert if ALERT_STATUSES.include?(alert) }
  end

