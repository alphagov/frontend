class ServiceManualServiceStandardController < ContentItemsController
  include Cacheable

  def index
    @presenter = ServiceManualServiceStandardPresenter.new(@content_item)
  end
end
