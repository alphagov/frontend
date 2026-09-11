class NewsArticleController < ContentItemsController
  include Cacheable

  layout "header_content_sidebar"

  def show
    @content_item_presenter = NewsArticlePresenter.new(content_item)
  end
end
