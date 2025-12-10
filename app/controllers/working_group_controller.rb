class WorkingGroupController < ContentItemsController
  include Cacheable

  def show
    @presenter = WorkingGroupPresenter.new(content_item)
  end
end
