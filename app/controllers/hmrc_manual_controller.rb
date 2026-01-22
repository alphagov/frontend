class HmrcManualController < ContentItemsController
  include Cacheable

  def show
    @presenter = HmrcManualPresenter.new(content_item)
  end
end
