module Phases
  extend ActiveSupport::Concern

  def opening_date_time
    content_store_response.dig("details", "opening_date")
  end

  def closing_date_time
    content_store_response.dig("details", "closing_date")
  end

  def open?
    content_store_response["document_type"] == "open_#{schema_name}"
  end

  def closed?
    ["closed_#{schema_name}", "#{schema_name}_outcome"].include? content_store_response["document_type"]
  end

  def unopened?
    content_store_response["document_type"] == schema_name
  end
end
