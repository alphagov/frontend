module Manual
  extend ActiveSupport::Concern

  def section_groups
    content_store_response.dig("details", "child_section_groups") || []
  end

  def manual?
    %w[manual manual_section].include?(content_item.schema_name)
  end
end
