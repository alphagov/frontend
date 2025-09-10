class Consultation < ContentItem
  include Attachments
  include NationalApplicability
  include People
  include Political
  include SinglePageNotificationButton
  include Updatable

  def contributors
    organisations + people
  end

  def opening_date_time
    content_store_response.dig("details", "opening_date")
  end

  def closing_date_time
    content_store_response.dig("details", "closing_date")
  end

  def open?
    content_store_response["document_type"] == "open_consultation"
  end

  def closed?
    %w[closed_consultation consultation_outcome].include? content_store_response["document_type"]
  end

  def unopened?
    !open? && !closed?
  end

  def final_outcome?
    content_store_response["document_type"] == "consultation_outcome"
  end

  def pending_final_outcome?
    closed? && !final_outcome?
  end

  def final_outcome_detail
    content_store_response.dig("details", "final_outcome_detail")
  end

  # Read the full outcome, top of page
  def final_outcome_attachments_for_components
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
    items = [].push(*final_outcome_attachments_for_components)
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

private

  def ways_to_respond
    content_store_response.dig("details", "ways_to_respond")
  end
end
