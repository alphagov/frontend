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

    inaccessible_attachments_with_email(items)
  end

  def public_feedback_detail
    content_store_response.dig("details", "public_feedback_detail")
  end
end
