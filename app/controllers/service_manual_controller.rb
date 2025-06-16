class ServiceManualController < ContentItemsController
  include Cacheable

  def index
    slimmer_template "gem_layout_full_width"
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
