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
  end
end
