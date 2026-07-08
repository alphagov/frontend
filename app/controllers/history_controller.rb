class HistoryController < ContentItemsController
  include Cacheable

  layout "header_sidebar_content"

  def show
    @content_item_presenter = ContentItemPresenter.new(content_item)
  end
end
