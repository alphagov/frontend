module WaysToRespond
  extend ActiveSupport::Concern

  def held_on_another_website_url
    content_store_response.dig("details", "held_on_another_website_url")
  end
end
