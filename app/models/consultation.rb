class Consultation < ContentItem
  include Attachments
  include NationalApplicability
  include People
  include Phases
  include Political
  include SinglePageNotificationButton
  include Updatable
  include WaysToRespond

  def lead_paragraph
    false
  end

  def contributors
    organisations + people
  end

  def pending_final_outcome?
    closed? && !outcome?
  end

  def final_outcome_detail
    content_store_response.dig("details", "final_outcome_detail")
  end

  # Read the full outcome, top of page
  def final_outcome_attachments
    attachments_from(content_store_response.dig("details", "final_outcome_attachments"))
  end

  # Feedback received, middle of page
  def public_feedback_attachments
    attachments_from(content_store_response.dig("details", "public_feedback_attachments"))
  end

  def attachments_with_details
    items = [].push(*final_outcome_attachments)
    items.push(*public_feedback_attachments)
    items.push(*featured_attachments)
    items.select { |doc| doc["accessible"] == false && doc["alternative_format_contact_email"] }
  end

  def public_feedback_detail
    content_store_response.dig("details", "public_feedback_detail")
  end

  def response_form?
    attachment_url.present? && (email.present? || postal_address.present?)
  end
end
