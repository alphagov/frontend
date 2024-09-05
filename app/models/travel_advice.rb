class TravelAdvice < ContentItem
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
end