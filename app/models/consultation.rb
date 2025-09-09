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
end
