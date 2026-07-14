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
    @presenter = ServiceManualGuidePresenter.new(content_item)
  end

  def service_manual_topic
    @presenter = ServiceManualTopicPresenter.new(content_item)
  end
end
