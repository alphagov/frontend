class CallForEvidence < ContentItem
  include Attachments
  include NationalApplicability
  include Political
  include SinglePageNotificationButton
  include Updatable

  def contributors
    organisations + people
  end

  def people
    content_store_response.dig("links", "people") || []
  end

  def open?
    content_store_response["document_type"] == "open_call_for_evidence"
  end

  def closed?
    %w[closed_call_for_evidence call_for_evidence_outcome].include? content_store_response["document_type"]
  end

  def unopened?
    !open? && !closed?
  end

  def outcome?
    content_store_response["document_type"] == "call_for_evidence_outcome"
  end

  def outcome_detail
    content_store_response.dig("details", "outcome_detail")
  end

  # Read the full outcome, top of page
  def outcome_documents
    attachments_from(content_store_response.dig("details", "outcome_attachments"))
  end

  # Documents, bottom of page
  def general_documents
    attachments_from(content_store_response.dig("details", "featured_attachments"))
  end

  def attachments_with_details
    items = [].push(*outcome_documents)
    items.push(*general_documents)
    items.select { |doc| doc["accessible"] == false && doc["alternative_format_contact_email"] }.count
  end

  def held_on_another_website?
    held_on_another_website_url.present?
  end

  def held_on_another_website_url
    content_store_response.dig("details", "held_on_another_website_url")
  end

  def ways_to_respond?
    open? && ways_to_respond && (respond_online_url || email || postal_address)
  end

  def email
    ways_to_respond["email"]
  end

  def postal_address
    ways_to_respond["postal_address"]
  end

  def respond_online_url
    ways_to_respond["link_url"]
  end

  def response_form?
    attachment_url && (email || postal_address)
  end

  def attachment_url
    ways_to_respond["attachment_url"]
  end

private

  def ways_to_respond
    content_store_response.dig("details", "ways_to_respond")
  end
end
