class ManualController < ContentItemsController
  include Cacheable

  def show
    @presenter = ManualPresenter.new(content_item)
  end
end
