class StatisticalDataSetController < ContentItemsController
  include Cacheable
  layout "header_content_sidebar"

  def show
    @content_item_presenter = StatisticalDataSetPresenter.new(content_item)
  end
end
