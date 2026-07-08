class FieldOfOperationController < ContentItemsController
  include Cacheable

  layout "header_sidebar_content"

  def show
    @content_item_presenter = FieldOfOperationPresenter.new(@content_item)
  end
end
