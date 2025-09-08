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
end
