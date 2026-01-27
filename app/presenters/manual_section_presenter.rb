class ManualSectionPresenter < ContentItemPresenter
  include ManualMetadata

  def page_title
    "#{content_item.manual_title} - #{content_item.title} - Guidance"
  end
end
