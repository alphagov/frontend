module Manual
  extend ActiveSupport::Concern

  def section_groups
    content_store_response.dig("details", "child_section_groups") || []
  end
end
