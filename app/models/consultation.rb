class Consultation < ContentItem
  include Attachments
  include NationalApplicability
  include People
  include Phases
  include Political
  include SinglePageNotificationButton
  include Updatable

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
  def public_feedback_attachments_for_components
    attachments_from(content_store_response.dig("details", "public_feedback_attachments"))
  end

  # Documents, bottom of page
  def documents_attachments_for_components
    attachments_from(content_store_response.dig("details", "featured_attachments"))
  end

  def attachments_with_details
    items = [].push(*final_outcome_attachments)
    items.push(*public_feedback_attachments_for_components)
    items.push(*documents_attachments_for_components)
    items.select { |doc| doc["accessible"] == false && doc["alternative_format_contact_email"] }
  end

  def public_feedback_detail
    content_store_response.dig("details", "public_feedback_detail")
  end

  def held_on_another_website_url
    content_store_response.dig("details", "held_on_another_website_url")
  end

  def held_on_another_website?
    held_on_another_website_url.present?
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

  def ways_to_respond?
    open? && (respond_online_url.present? || email.present? || postal_address.present?)
  end

  def response_form?
    attachment_url.present? && (email.present? || postal_address.present?)
  end

private

  def ways_to_respond
    content_store_response.dig("details", "ways_to_respond")
  end
end
