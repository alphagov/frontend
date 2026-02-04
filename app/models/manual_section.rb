class ManualSection < ContentItem
  include ManualSections
  include ManualLike

  delegate :for_contextual_breadcrumbs, to: :manual_content_item
end
