class ManualSectionPresenter < ContentItemPresenter
  include ManualMetadata
  include ManualPageTitle

  def page_title
    "#{breadcrumb} - #{manual_page_title}"
  end
end
