class CallForEvidence < ContentItem
  include Attachments
  include NationalApplicability
  include People
  include Phases
  include Political
  include SinglePageNotificationButton
  include Updatable
  include WaysToRespond

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

  def attachments_with_details
    items = [].push(*outcome_documents)
    items.push(*featured_attachments)
    items.select { |doc| doc["accessible"] == false && doc["alternative_format_contact_email"] }
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
end
