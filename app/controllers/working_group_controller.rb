class WorkingGroupController < ContentItemsController
  include Cacheable

  def show
    @content_item_presenter = WorkingGroupPresenter.new(content_item)
    render layout: "header_content_sidebar"
  end
end
