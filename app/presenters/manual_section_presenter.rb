class ManualSectionPresenter < ContentItemPresenter
  include ManualMetadata
  include ManualPageTitle

  def page_title
    "#{content_item.breadcrumb} - #{manual_page_title}"
  end
end
