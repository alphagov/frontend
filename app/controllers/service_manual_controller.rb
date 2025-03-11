class ServiceManualController < ContentItemsController
  include Cacheable
  slimmer_template "gem_layout_full_width"

  def index
    @presenter = ServiceManualHomepagePresenter.new(content_item)
  end
end
