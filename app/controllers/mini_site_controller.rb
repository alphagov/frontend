class MiniSiteController < ContentItemsController
  def show
    @content_item_presenter = MiniSitePresenter.new(content_item)
  end
end
