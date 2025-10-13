module WaysToRespond
  extend ActiveSupport::Concern

  def held_on_another_website_url
    content_store_response.dig("details", "held_on_another_website_url")
  end

  def held_on_another_website?
    held_on_another_website_url.present?
  end

  def ways_to_respond?
    open? && (respond_online_url.present? || email.present? || postal_address.present?)
  end

  def email
    ways_to_respond["email"] if ways_to_respond
  end

  def postal_address
    ways_to_respond["postal_address"] if ways_to_respond
  end

  def respond_online_url
    ways_to_respond["link_url"] if ways_to_respond
  end

private

  def ways_to_respond
    content_store_response.dig("details", "ways_to_respond")
  end
end
