class HelpPageController < ContentItemsController
  layout "header_content_sidebar"

  def show
    @content_item_presenter = ContentItemPresenter.new(content_item)
  end
end
