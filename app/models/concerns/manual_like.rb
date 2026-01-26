module ManualLike
  extend ActiveSupport::Concern

  def section_groups
    content_store_response.dig("details", "child_section_groups") || []
  end

  def manual?
    %w[hmrc_manual manual manual_section].include?(schema_name)
  end
end
