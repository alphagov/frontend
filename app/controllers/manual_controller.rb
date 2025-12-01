class ManualController < ContentItemsController
  include Cacheable

  def show
    @manual_presenter = ManualPresenter.new(content_item)
  end
end
