class ManualPresenter < ContentItemPresenter
  include ManualBreadcrumbs
  include ManualMetadata

  def initialize(content_item, request = nil)
    super(content_item)
    @request = request
  end

  def main_breadcrumbs
    breadcrumb_selector
  end
end
