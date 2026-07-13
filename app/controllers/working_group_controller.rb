class WorkingGroupController < ContentItemsController
  include Cacheable

  def show
    @content_item_presenter = WorkingGroupPresenter.new(content_item)
  end
end
