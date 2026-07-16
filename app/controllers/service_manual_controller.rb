class ServiceManualController < ContentItemsController
  include Cacheable

  def index
    @presenter = ServiceManualHomepagePresenter.new(content_item)
    render layout: "full_width"
  end

  def service_standard
    @content_item_presenter = ServiceManualServiceStandardPresenter.new(content_item)
    render layout: "header_content_sidebar"
  end

  def service_manual_guide
    @content_item_presenter = ServiceManualGuidePresenter.new(content_item)
    render layout: "header_sidebar_content"
  end

  def service_manual_topic
    @content_item_presenter = ServiceManualTopicPresenter.new(content_item)
    render layout: "header_content_sidebar"
  end
end
