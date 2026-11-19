class HmrcManualUpdatesPresenter < ManualUpdatesPresenter
  include ManualBreadcrumbs

  def initialize(content_item, request = nil)
    super(content_item)
    @request = request
  end

  def main_breadcrumbs
    return unless breadcrumb_selector

    breadcrumb_selector << {
      title: content_item.title,
      url: content_item.base_path,
    }
  end
end
