class StatisticalDataSetController < ContentItemsController
  include Cacheable

  def show
    @presenter = StatisticalDataSetPresenter.new(content_item)
  end
end
