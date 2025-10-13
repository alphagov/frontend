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

  def final_outcome_detail
    content_store_response.dig("details", "outcome_detail")
  end

  # Read the full outcome, top of page
  def final_outcome_attachments
    attachments_from(content_store_response.dig("details", "outcome_attachments"))
  end

  def attachments_with_details
    items = [].push(*final_outcome_attachments)
    items.push(*featured_attachments)

    inaccessible_attachments_with_email(items)
  end

  def lead_paragraph
    false
  end
end
