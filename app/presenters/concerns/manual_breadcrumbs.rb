module ManualBreadcrumbs
  def breadcrumb_selector
    return unless @request

    breadcrumbs = GovukPublishingComponents::Presenters::BreadcrumbSelector.new(content_item.for_contextual_breadcrumbs, @request, false)
    breadcrumbs.breadcrumbs
  end
end
