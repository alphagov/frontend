class CallForEvidence < ContentItem
  include Attachments
  include NationalApplicability
  include People
  include Phases
  include Political
  include SinglePageNotificationButton
  include Updatable

  def contributors
    organisations + people
  end

  def outcome_detail
    content_store_response.dig("details", "outcome_detail")
  end

  # Read the full outcome, top of page
  def outcome_documents
    attachments_from(content_store_response.dig("details", "outcome_attachments"))
  end

  # Documents, bottom of page
  def featured_attachments
    attachments_from(content_store_response.dig("details", "featured_attachments"))
  end

  def attachments_with_details
    items = [].push(*outcome_documents)
    items.push(*featured_attachments)
    items.select { |doc| doc["accessible"] == false && doc["alternative_format_contact_email"] }
  end

  def held_on_another_website?
    held_on_another_website_url.present?
  end

  def held_on_another_website_url
    content_store_response.dig("details", "held_on_another_website_url")
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

  def attachment_url
    ways_to_respond["attachment_url"] if ways_to_respond
  end

  def response_form?
    attachment_url.present? && (email.present? || postal_address.present?)
  end

  def lead_paragraph
    false
  end

private

  def ways_to_respond
    @ways_to_respond ||= content_store_response.dig("details", "ways_to_respond")
  end
end
