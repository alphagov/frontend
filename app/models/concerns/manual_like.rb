module ManualLike
  extend ActiveSupport::Concern

  def section_groups
    content_store_response.dig("details", "child_section_groups") || []
  end

  def manual?
    %w[manual manual_section].include?(schema_name)
  end

  def manual_base_path
    manual_content_item.base_path
  end

  def manual_content_item
    @manual_content_item ||= find_manual_content_item
  end

private

  def find_manual_content_item
    return self if %w[manual hmrc_manual].include?(schema_name)

    linked_manual = linked("manual").first
    return linked_manual if linked_manual

    response = ContentItemLoaders::ContentStoreLoader.new.load(base_path: content_store_response&.dig("details", "manual", "base_path"))
    ContentItemFactory.build(response)
  end
end
