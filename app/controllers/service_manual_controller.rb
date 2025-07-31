class ServiceManualController < ContentItemsController
  include Cacheable

  def index
    @presenter = ServiceManualHomepagePresenter.new(content_item)
  end

  def service_standard
    @presenter = ServiceManualServiceStandardPresenter.new(content_item)
  end

  def service_manual_guide
    @presenter = ServiceManualGuidePresenter.new(content_item)
  end

  def service_manual_topic
    @presenter = ServiceManualTopicPresenter.new(content_item)
  end
end
