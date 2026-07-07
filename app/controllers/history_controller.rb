class HistoryController < ContentItemsController
  include Cacheable

  layout "header_sidebar_content"

  def show
    @content_presenter = HistoryPresenter.new(content_item)
  end
end
