class CallForEvidence < ContentItem
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
end
